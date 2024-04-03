class InventoryItem < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :product_id, uniqueness:
    { scope: :store_id, message: ->(object, _) { "Product #{object.product.name} already exists for Store #{object.store.name}}" } }

  after_commit :check_inventory_level, on: %i[create update]

  LOW_INVENTORY_THRESHOLD = 10
  scope :with_low_quantity_and_associations, -> { where('quantity < ?', LOW_INVENTORY_THRESHOLD).includes(:store, :product) }

  def self.group_by_store_with_low_quantity
    with_low_quantity_and_associations.group_by(&:store).transform_values do |items|
      items.map do |item|
        {
          inventory_id: item.id,
          quantity: item.quantity,
          product_id: item.product_id,
          product_name: item.product.name
        }
      end
    end
  end

  private

  def check_inventory_level
    return if quantity >= LOW_INVENTORY_THRESHOLD

    broadcast_low_inventory
    notify_user
  end

  def notify_user
    LowInventoryNotifyRealtimeJob.perform_later
  end

  def broadcast_low_inventory
    ActionCable.server.broadcast('low_inventory_channel', serialize_data(self.class.group_by_store_with_low_quantity))
  end

  def serialize_data(data)
    serialized_data = {}
    data.each do |store, inventory_items|
      serialized_store = {
        store_id: store.id,
        store_name: store.name,
        inventory_items: inventory_items.map do |item|
          {
            inventory_id: item[:inventory_id],
            quantity: item[:quantity],
            product_id: item[:product_id],
            product_name: item[:product_name]
          }
        end
      }
      serialized_data[store.id] = serialized_store
    end
    serialized_data.to_json
  end
end
