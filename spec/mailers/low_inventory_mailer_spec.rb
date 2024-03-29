require 'rails_helper'

RSpec.describe LowInventoryMailer, type: :mailer do
  describe '#notify_user' do
    let(:low_inventories) do
      {
        store1: [{ product_name: 'Product1', quantity: 5 }],
        store2: [{ product_name: 'Product2', quantity: 3 }]
      }
    end
    let(:email) { 'test@example.com' }
    let(:mail) { described_class.notify_user(email:, low_inventories:).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Low Inventory Alert')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([email])
    end

    it 'renders the body with correct content' do
      expect(mail.body.encoded).to match('Inventory Tracking - Low Inventory')
      expect(mail.body.encoded).to match('Store: store1')
      expect(mail.body.encoded).to match('Product: Product1 | Quantity: 5')
      expect(mail.body.encoded).to match('Store: store2')
      expect(mail.body.encoded).to match('Product: Product2 | Quantity: 3')
    end
  end
end
