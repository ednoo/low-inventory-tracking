# Preview all emails at http://localhost:3000/rails/mailers/low_inventory
class LowInventoryMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/low_inventory/notify_user
  def notify_user
    LowInventoryMailer.notify_user
  end

end
