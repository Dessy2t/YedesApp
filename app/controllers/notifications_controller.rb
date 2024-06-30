class NotificationsController < ApplicationController

    def index
        user = current_user
        @seen = user.notifications.where('seen': true).order('created_at DESC')
        @new = user.notifications.where('seen': false).order('created_at DESC')
    end

    def update_notifications
        @notifications = current_user.notifications
        @notifications.update_all('seen': true)
        head :ok
    end

end
