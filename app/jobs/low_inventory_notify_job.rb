class LowInventoryNotifyJob < ApplicationJob
  queue_as :notification

  def perform
    NotifyUser.call(notification_type: :low_inventory, scheduled_notification: true)
  end
end
