class Notification < ApplicationRecord
  belongs_to :user, class_name: "User"
  after_create_commit -> { NotificationRelayJob.perform_later(self) }



  def self.send_notifitaion(sender,receiver,action,message)
    Notification.create( user_id: sender, recipient_id: receiver, action: action, message: message)
  end

 


end
