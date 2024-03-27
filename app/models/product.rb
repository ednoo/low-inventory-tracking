class Product < ApplicationRecord
  has_many :inventory_items, dependent: :destroy
  has_many :stores, through: :inventory_items
end
