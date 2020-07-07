class NotificationRelayJob < ApplicationJob
  queue_as :default
  
  def perform(notification)
  ActionCable.server.broadcast "notifications_channel_#{notification.recipient_id}", message: render_event(notification)
  end
  def render_event(notification)
   notify=Hash.new
   user= User.find_by(id: notification.user_id) 
     notify[:sender]= "#{user.first_name} #{user.last_name}"
     notify[:id]=notification.id
     notify[:action]=notification.action
     notify[:message]=notification.message
     notify
    # ApplicationController.renderer.render(partial: "notifications/invitations/#{notification.action}", locals: {notification: notification})
  end
end
