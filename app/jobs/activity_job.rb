class ActivityJob < ApplicationJob
  queue_as :default

  def perform(notification)
    ActionCable.server.broadcast "activity_channel_#{notification.user_id}", html: render_event(notification)
  end
  def render_event(notification)
    ApplicationController.renderer.render(partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification})
  end
end
