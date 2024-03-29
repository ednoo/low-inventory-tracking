class NotifyUser
  class << self
    def call(notification_type:, scheduled_notification: false)
      case notification_type
      when :low_inventory
        if scheduled_notification
          send_low_inventory_notification(scheduled_notification_users)
        else
          send_low_inventory_notification(realtime_notification_users)
        end
      else
        raise ArgumentError, "#{notification_type} is an unsupported type"
      end
    end

    private

    def send_low_inventory_notification(notifications)
      low_inventories = InventoryItem.group_by_store_with_low_quantity
      notifications.each do |user|
        LowInventoryMailer.notify_user(email: user.user.email, low_inventories:).deliver_now
      end
    end

    def realtime_notification_users
      NotificationSetting.where(real_time_notification: true).includes(:user)
    end

    def scheduled_notification_users
      NotificationSetting.where(real_time_notification: false).includes(:user)
    end
  end
end
