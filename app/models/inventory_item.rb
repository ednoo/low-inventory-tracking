class InventoryItem < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :product_id, uniqueness:
    { scope: :store_id, message: ->(object, _) { "Product #{object.product.name} already exists for Store #{object.store.name}}" } }

  after_save :check_inventory_level

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
    notify_user if quantity <= LOW_INVENTORY_THRESHOLD
  end

  def notify_user
    # @TODO
  end
end
