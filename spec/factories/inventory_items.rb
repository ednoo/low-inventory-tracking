FactoryBot.define do
  factory :inventory_item do
    association :store
    association :product
    quantity { Faker::Number.between(from: 1, to: 100) }
  end
end
