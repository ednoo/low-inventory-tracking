class LowInventoryMailer < ApplicationMailer
  def notify_user(email:, low_inventories:)
    @low_inventories = low_inventories
    mail to: email, subject: 'Low Inventory Alert'
  end
end
