class Store < ApplicationRecord
  has_many :inventory_items, dependent: :destroy
  has_many :products, through: :inventory_items

  scope :with_low_inventory, -> { joins(:inventory_items).where('inventory_items.quantity < ?', InventoryItem::LOW_INVENTORY_THRESHOLD) }

  def map_product_inventory
    inventory_items.includes(:product).map do |item|
      { id: item.id, product_name: item.product.name, product_id: item.product.id, quantity: item.quantity }
    end
  end
end
