class ConversationsController < ApplicationController
  include ActionView::Helpers::UrlHelper
  include CustomMethods
  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_conversation, only: [:show,:sentmsg,:reply,:get_box,:destroy,:restore]
  before_action :get_box, only: [:index]
  before_action :setup_user, only: [:send_message]

    def index
      received_invite=I18n.t('conversations.index.connect_invite');
      @message_box = params[:message_box]
      if (@message_box.eql? "all")
            @conversations =helpers.mailboxer_list(@mailbox, nil,params[:page],10,"all")
      elsif @message_box.eql? "received"
            @conversations = helpers.mailboxer_list(@mailbox,received_invite,params[:page],1000,"inbox")
      elsif @message_box.eql? "sent"
            @conversations = helpers.mailboxer_list(@mailbox,received_invite,params[:page],1000,"sentbox")
      elsif @message_box.eql? "others"
            @conversations = helpers.mailboxer_list(@mailbox,"No subject",params[:page],1000,"others")
      end
      messages_list=[];
      
      @conversations.each do |i|
        if (@message_box.eql? "received") ||  (@message_box.eql? "sent")
          interest = Interest.find_by_conv_id(i.id)
          if interest.present?
            if interest.state=='awaiting_response' && i.participants.size>1
              messages_list.push(msg_creation(i)) 
            end
          end
        else
          if i.participants.size>1
           messages_list.push(msg_creation(i)) 
          end
        end
          
      end
      render json: {conversation: messages_list}
    end

    def messages_count 
      render json: {:message => @unreadmsg}
    end
    def get_conversations
      subject = params[:subject]
      reciver_id = params[:user_id]
      user = User.find params[:user_id].to_i
      mails = user.mailbox.conversations.where(:subject => subject)
      user_type=UserRole.get_roles(current_user)
      messages_list=[]
      if subject.present?
        mails.reorder(id: :asc).each do |conversation|
          messages = conversation.messages.order(:updated_at)
          messages_list += CustomMethods.format_conversation(messages,conversation,current_user,user_type)
        end
      end
      render json: {messages: messages_list}
    end

   

    def get_workflow_history
      subject = params[:subject]
      reciver_id = params[:user_id]
      user_type=UserRole.get_roles(current_user)
      messages_list=[]
      workflow_list = WorkflowStatus.where(user_id:reciver_id).reorder(id: :asc)
      workflow_list.each do |workflow|
        item=Hash.new
        item[:sender_id]=workflow.user_id
        item[:current_id]=current_user.id
        item[:message]=workflow.comment
        item[:conv_id]=workflow.user_id
        item[:user_type]=user_type
        item[:subject]=workflow.comment
        item[:state]=workflow.state
        item[:time]=workflow.created_at
        item[:receiver_name]="Remove this"
        messages_list.push(item)
      end
      render json: {messages: messages_list}
    end

    def show
      @conversation = @mailbox.conversations.find(params[:id])
      @conversation.mark_as_read(current_user) if @conversation.is_unread?(current_user)
      user_record=@conversation.participants.reject{|u|(u.id==current_user.id)}.first
      name="#{user_record.first_name} #{user_record.last_name}" 
      mailbox_type=  @conversation.receipts.where(:receiver_id => current_user.id).first.mailbox_type
      interest= Interest.where(user_to:current_user.id,user_id:user_record.id).first
      conv_interest= Interest.where(conv_id:params[:id]).first
      if  interest.blank?
        interest= Interest.where(user_id:current_user.id ,user_to:user_record.id).first
      end
      render json: {photo: user_record.photos , profile: user_record.profile, name: name,
        messages: @conversation.messages,
        subject: @conversation.subject,
        user:user_record,
        mailbox_type:mailbox_type,
        conv_interest:conv_interest,
        messagesByOrder:@conversation.messages.order(:updated_at),
        interest: interest}
    end
    
    def send_message
      recipients=User.find_by_id(get_message[:user_to].to_i)
      @subject = I18n.t('milan.subject.message',name: @user_model.position)
      @user_model.send_message(recipients,get_message[:message], @subject)
      Notification.send_notifitaion(@user_model.id,recipients.id,"Message",get_message[:message])
      MilanMailer.received_msg(recipients).deliver_later
      render json: {:result => true}
    end

   
    def workflow_reply
      #current_user.reply_to_conversation(@conversation, params[:body])
      @profile = Profile.find_by_user_id(params[:id])
      recipients = current_user
      if params[:id] != current_user.id
        recipients = User.find(params[:id])
      end
      if params[:id].to_i == current_user.id  #For User
        recipients=User.get_user_manager(current_user.region).first    
        if @profile.profile_state=='being_reviewed'
          Profile.change_state("Member Response",@profile,"MEMBER")
        elsif profile_flow[:state]=='delete'
          Profile.change_state("Deactivate Member",@profile,"MEMBER")
        end
        MilanMailer.notify_regional(recipients).deliver_later  #notify regional manager
      else   
        MilanMailer.received_msg(recipients).deliver_later #send msg to user
      end
      helpers.states_handling(@profile,@profile.profile_state,profile_flow[:message])
      render json:{message: I18n.t('conversations.reply.reply_sent') } 
    end

    def reply
      current_user.reply_to_conversation(@conversation,  get_message[:message])
      user_response = get_message[:user_response].present? ? true : false
      if @conversation.subject=="Need more information"
        user_response = true
      end
      @profile = Profile.find_by_user_id(current_user.id)
      if user_response
        if get_message[:user_id].present?
          @profile = Profile.find_by_user_id(get_message[:user_id])
          WorkflowStatus.regional_admin_workflow(get_message[:message],'profile',@profile.current_state.name,@profile.user_id)
        else
          participants = @conversation.participants
          participants.each do |participant|
            begin
              user = User.find participant.id
              user_type=user.position
              if user_type=="Admin" || user_type=="Manager"
              else
                @profile = Profile.find_by_user_id(user.id)
                WorkflowStatus.regional_admin_workflow(get_message[:message],'profile',@profile.current_state.name,@profile.user_id)
              end
            rescue => exception
            end
        end
      end
       
       
      end
      recipients=@conversation.participants.reject{|u|(u.id==current_user.id)}
      #When user reply to Admin/Regional manager
      if @profile.profile_state=='being_reviewed' &&  !((UserRole.get_roles(current_user).include?'GBL') || (UserRole.get_roles(current_user).include?'RGN')) && user_response
          @profile.response_to_request!    
          # MilanMailer.notify_regional(recipients).deliver_later
      else
        user_type=current_user.position
        if user_type=="Admin" || user_type=="Manager"
          if @profile.profile_state =="awaiting_review" || @profile.profile_state=="new"
            @profile.need_more_info!    
          end
        end
        # MilanMailer.received_msg(recipients).deliver_later
      end
      recipients.each do |recipient|
        user_type=recipient.position
        if user_response
          MilanMailer.notify_regional(recipient).deliver_later
        else
          MilanMailer.received_msg(recipient).deliver_later
        end
      end
      render json:{message:I18n.t('conversations.reply.reply_sent') } 
    end
    
    def get_box
      if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
        params[:box] = 'inbox'
      end
      @box = params[:box]
    end
    
 
   

    def destroy_conversation
     ids = params[:conversation][:conv_id]
      #remove
     ids.each do |id|
        conversation = @mailbox.conversations.find(id)
        conversation.move_to_trash(current_user)
        conversation.mark_as_deleted(current_user)
      end
     render json: {:result => true}
    end
    
    # def restore
    #   @conversation.untrash(current_user)
    #   flash[:success] =t('.restored')
    #   redirect_to conversations_path
    # end
  
    # def empty_trash
    #   @mailbox.trash.each do |conversation|
    #     conversation.receipts_for(current_user).update_all(deleted: true)
    #   end
    #   flash[:success] = t('.clean')
    #   redirect_to conversations_path
    # end
  
    private

    def msg_creation(data)
      item=Hash.new   #remove profilelink,profile_id from js
      item[:message]=data.messages.last.body
      item[:new]=data.is_unread?(current_user)
      item[:conv_id]=data.id
      item[:subject]=data.subject
      item[:time]=data.updated_at
      item[:mailbox_type]=data.receipts.where(:receiver_id => current_user.id).first.mailbox_type
      item[:receiver_name]=data.receipts.reject { |p| p.receiver.id == current_user.id }.collect {|p| ("#{p.receiver.first_name} #{p.receiver.last_name }")}.uniq.join(" ,")
      if item[:mailbox_type]=='sentbox' && item[:subject]== I18n.t('admin.inbox.connect_invite')
        item[:subject]='You have sent invitation to connect'
      elsif (item[:mailbox_type]=='sentbox') && (item[:subject].include? 'has accepted your invitation')
        item[:subject]="You have accepted #{item[:receiver_name]} invitation"
      elsif (item[:mailbox_type]=='sentbox') && (item[:subject].include? 'is no longer connected with you')
        item[:subject]="You are no longer connected with #{item[:receiver_name]}"
      end
     
      item
    end
    def setup_user
        @user_model=User.new
        @user_model=current_user
    end
    def get_conversation
      begin
        @conversation ||= @mailbox.conversations.find(params[:id])
        rescue Exception => e
            @conversation = Mailboxer::Conversation.find params[:id]
            if @conversation.present?
              @conversation.add_participant(current_user)
            end
         
      end
    end
    def get_mailbox
      @mailbox ||= current_user.mailbox
      @unreadmsg=@mailbox.inbox(:read => false).count(:id).to_s
    end
    def get_message
      params.require(:conversation).permit([:user_to,:subject,:message,:user_response,:conv_id,:user_id])
    end
    def profile_flow
      params.require(:workflow).permit([:message,:state])
    end
  end

  