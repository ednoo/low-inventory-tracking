class LowInventoryNotifyRealtimeJob < ApplicationJob
  queue_as :realtime

  def perform
    NotifyUser.call(notification_type: :low_inventory, scheduled_notification: false)
  end
end
