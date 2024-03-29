require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }
    it 'validates presence of quantity' do
      inventory_item = InventoryItem.new(quantity: nil)
      inventory_item.valid?
      expect(inventory_item.errors[:quantity]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { should belong_to(:store) }
    it { should belong_to(:product) }
  end

  describe 'callbacks' do
    describe '#check_inventory_level' do
      context 'when quantity is below the low inventory threshold' do
        it 'calls notify_user' do
          inventory_item = create(:inventory_item, quantity: 9)
          expect(inventory_item).to receive(:notify_user)
          inventory_item.save
        end
      end

      context 'when quantity is above the low inventory threshold' do
        it 'will not call notify_user' do
          inventory_item = FactoryBot.create(:inventory_item, quantity: 11)
          expect(inventory_item).not_to receive(:notify_user)
          inventory_item.save
        end
      end
    end
  end

  describe 'scopes' do
    describe '.with_low_quantity_and_associations' do
      it 'returns inventory items with quantity below low inventory threshold' do
        low_quantity_item = create(:inventory_item, quantity: 5)
        above_quantity_threshold = create(:inventory_item, quantity: 15)
        expect(InventoryItem.with_low_quantity_and_associations).to include(low_quantity_item)
        expect(InventoryItem.with_low_quantity_and_associations).not_to include(above_quantity_threshold)
      end
    end
  end

  describe '.group_by_store_with_low_quantity' do
    it 'groups by store with low quantity and includes product details' do
      store1 = create(:store)
      store2 = create(:store)
      low_quantity_item1 = create(:inventory_item, quantity: 5, store: store1)
      create(:inventory_item, quantity: 7, store: store1)

      result = InventoryItem.group_by_store_with_low_quantity

      expect(result.keys).to include(store1)
      expect(result.keys).not_to include(store2)
      expect(result[store1].size).to eq(2)
      expect(result[store1].first[:inventory_id]).to eq(low_quantity_item1.id)
      expect(result[store1].first[:quantity]).to eq(low_quantity_item1.quantity)
      expect(result[store1].first[:product_id]).to eq(low_quantity_item1.product_id)
      expect(result[store1].first[:product_name]).to eq(low_quantity_item1.product.name)
    end
  end
end
