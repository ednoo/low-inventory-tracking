module Admin
  class NotificationSettingsController < ApplicationController
    before_action :current_user_notification_setting

    def edit; end

    def update
      if @notification_setting.update(notification_setting_params)
        flash[:notice] = 'Settings updated.'
      else
        flash[:alert] = 'Error when trying to update settings.'
      end
      redirect_to edit_admin_notification_setting_path
    end

    private

    def notification_setting_params
      params.require(:notification_setting).permit(:frequency, :next_notification_at, :real_time_notification)
    end

    def current_user_notification_setting
      @notification_setting = current_user.notification_setting || current_user.build_notification_setting
    end
  end
end
