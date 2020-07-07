class InterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_interest, only: [:respond]
def send_request
   invite_request()
   ProfileMatch.remove_from_match(current_user.id,send_invite_param[:user_to].to_i)
   render json: {:result =>  @return_message }
end

def respond
  # conversation_list= @interest.user.mailbox.conversations.map { |c| c.receipts.where(receiver_id: @interest.user_to) }
  # conversation_list.each do |item|
  #   if item.present?
  #     receipts=Mailboxer::Receipt.where(notification_id:item.pluck(:notification_id))
  #     receipts.each do |receipt|
  #       receipt.move_to_trash
  #     end
     
  #   end
  # end
  invite_request()
   render json: {:result =>  @return_message }
end

def send_reminder

  recipient=User.find(send_invite_param[:user_to].to_i)
  url=ENV['FRONTEND_URL']
  @interest = Interest.select(Arel.star).where(
    Interest.arel_table[:user_id].eq(recipient.id).and(Interest.arel_table[:user_to].eq(current_user.id)).or(
      Interest.arel_table[:user_id].eq(current_user.id).and(Interest.arel_table[:user_to].eq(recipient.id))
    )
  )
  
  if @interest.present?
    @interest.first.notified_on=Time.now
    @interest.first.save
    url= "#{ENV['FRONTEND_URL']}messages/#{@interest.first.conv_id}/other"
  end
  MilanMailer.reminder(recipient,url).deliver_later
  render json: "sent"
   #in progress
end

def all_interests
  ids=Interest.sent(current_user.id) + Interest.received(current_user.id)
  render json: ids
end

private
 def get_interest # tracing id to trash for received/sent
   @interest= Interest.find_by(id:send_invite_param[:user_to].to_i) 
   if @interest.user_id == current_user.id
    @user = User.find(current_user.id)
   else
    @user = User.find(current_user.id)
   end
 end

 def invite_request
    @return_message = true
    if send_invite_param.present?
    helpers.user_interests(send_invite_param[:user_to].to_i,send_invite_param[:action],send_invite_param[:message])
    else
      @return_message = false
    end
end
#user_to is receiver/ interest_id
def send_invite_param
 params.require(:interest).permit([:user_to,:action, :message])
end

end
