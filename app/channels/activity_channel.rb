class ActivityChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "activity_channel"#_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
