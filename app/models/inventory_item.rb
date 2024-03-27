class InventoryItem < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :product_id, uniqueness:
    { scope: :store_id, message: ->(object, _) { "Product #{object.product.name} already exists for Store #{object.store.name}}" } }
end
