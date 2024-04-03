class NotifyUser
  class << self
    def call(notification_type:, scheduled_notification: false)
      case notification_type
      when :low_inventory
        if scheduled_notification
          send_low_inventory_notification(notifications: scheduled_notification_users)
        else
          send_low_inventory_notification(notifications: realtime_notification_users)
        end
      else
        raise ArgumentError, "#{notification_type} is an unsupported type"
      end
    end

    private

    def send_low_inventory_notification(notifications:)
      low_inventories = InventoryItem.group_by_store_with_low_quantity
      notifications.each do |notification|
        LowInventoryMailer.notify_user(email: notification.user.email, low_inventories:).deliver_now
        handle_next_notification(notification)
      end
    end

    def realtime_notification_users
      NotificationSetting.where(real_time_notification: true).includes(:user)
    end

    def scheduled_notification_users
      NotificationSetting.where(real_time_notification: false).includes(:user)
    end

    def handle_next_notification(notification)
      return if notification.real_time_notification?

      notification.next_notification_at = 1.day.from_now if notification.frequency == 'daily'
      notification.next_notification_at = 1.hour.from_now if notification.frequency == 'hourly'
      notification.save!
    end
  end
end
