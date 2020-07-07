class AdminController < ApplicationController
  include ActionView::Helpers::UrlHelper
  # require 'will_paginate/array' 
 before_action :authenticate_admin
 before_action :get_mailbox, only: [:index,:inbox,:conversation,:inbox_count,:workflow_action]
 before_action :profile_count, only: [:getprofile]

 def workflow_action 
  
      workflow=WorkflowStatus.new(workflowparams) 
      user_model=User.new
      user_model=current_user
      profile=  Profile.find_by_user_id workflow.user_id #need changes
      profile=  Profile.change_state(params["action_type"], profile, user_model.position)
      helpers.states_handling(profile,profile.profile_state,workflow.comment)
    render json: {
        status: 200,
        message: true
     }.to_json
 end


def region_selection
     user_model= User.new
     user_model=params[:id].present? ? User.find_by_id(params[:id]) : User.find_by_id(current_user.id)
     render json: user_model.available_regions
end

def manager_regions
  user_model=  User.new
  user_model=User.find_by(id: userparam[:id])
  user_counts=0
  msg=''
  if userparam[:region].present?
  user_regions=  user_model.region.gsub(', ',',').split(',').map(&:to_s)
   removed_regions= user_regions - (user_regions & userparam[:region])
    if removed_regions.present?
        removed_regions.each do |reg|
          user_counts+=User.get_members.where(region: reg).where.not('confirmed_at' => nil).size
        end
       msg=I18n.t('milan.reg_con',{count:user_counts,region: removed_regions.to_sentence.gsub(', and',' and')}) 
    else
      msg= I18n.t('milan.no_reg_con')
    end
  end
   render json: msg
end


def destroy
  user=User.find_by(id: params[:id])
    if user.destroy
      render json: {
      status: 200,
      message: true
      }.to_json
  else
      render json: {
      status: 422,
      message: true
      }.to_json
    end
end



def inbox_count
  all =@mailbox.conversations({:mailbox_type => 'not_trash'}).where.not(:subject => "Need more information")
  by_manager=0
  by_member=0
  all.each do |i|
  user_type = i.receipts.where.not(:receiver_id => current_user.id).first
  if user_type.present?
    user_model = User.find(i.receipts.where.not(:receiver_id => current_user.id).first.receiver_id)
    user_type=user_model.position
    if (user_type=='Manager') ||  (user_type=='Admin') && i.participants.size>1
      by_manager= by_manager+1
    elsif (user_type=='Member') && i.participants.size>1
      by_member=by_member+1
    end
  end
    

  end
  #by_manager =@mailbox.inbox.where(:subject => 'Manager message').count().to_s
  #by_member =@mailbox.inbox.where(:subject => 'Member message').count().to_s
  other =helpers.mailboxer_list(@mailbox, 'all',nil,nil,'inbox').count().to_s
  sent =@mailbox.sentbox.count().to_s
  render json: {
    all: all.count().to_s,
    by_manager:by_manager,
    by_member:by_member,
    other:other,
    sent:sent

 }.to_json
end


def create_manager
  new_profile = sign_up_params
  new_profile[:password] = I18n.t('milan.default_password')
  user= User.create(new_profile)
  user.expiration_date=Time.now + 3.years
  user.confirmed_at = DateTime.now
  if user.save
  user.user_roles.create(profile_for_params)
  Profile.manager_profile(user)
  if profile_for_params[:role_id]=="2"
    MilanMailer.email_confirmations(user,"regional manger").deliver_later 
  else
    MilanMailer.email_confirmations(user,"admin").deliver_later 
  end
 
  else
  render json: user.errors.messages
  end  
  render json: "Successfully created Regional Manager"
end

 def request_count
  filter=""
      age_from = params[:age_from]
      age_to = params[:age_to]
      gender = params[:gender]
      region = params[:region]
      name = params[:name]
     
      profile_state = params[:profile_state]
      
      user_type=UserRole.get_roles(current_user)
      managers_list =  ActiveRecord::Base.connection.execute('select users.first_name,users.last_name,users.region from users join user_roles on users.id=user_roles.user_id where user_roles.role_id=2')
      if(!profile_state.present? && profile_state !='null' )
        filter= filter << " and p.profile_state='" << profile_state <<"'"
      end
      if(age_from.present? && age_from !='null' )
        filter= filter << ' and EXTRACT(YEAR FROM age(p.dob)) >=' << age_from
      end
      if(age_to.present? && age_to !='null' )
        filter= filter << ' and EXTRACT(YEAR FROM age(p.dob)) <=' << age_to
      end
      if(gender.present? && gender !='null' )
        filter= filter << " and LOWER(p.gender)='" << gender <<"'"
      end
      # if(region.present? && region !='null' )
      #   filter= filter << " and u.region='" << region <<"'"
      # end
      if(profile_state.present? && profile_state !='null' )
        filter= filter << " and p.profile_state='" << profile_state <<"'"
      end
      if(name.present? && name !='null' )
        name = name.downcase
        split_name = name.split(' ')
        filter= filter << " and LOWER(u.first_name) LIKE '%" << split_name[0] <<"%'"
        filter= filter << " or LOWER(u.last_name) LIKE '%" << split_name[0] <<"%'"
        if split_name[1].present?
          filter= filter << " or LOWER(u.last_name) LIKE '%" << split_name[1] <<"%'"
          filter= filter << " or LOWER(u.first_name) LIKE '%" << split_name[1] <<"%'"
        end
      end
      
      @state = params[:state]
      if region.present? && region !='null'
        if region.include? "Default"
          available_regions = current_user.available_regions;
          available_regions.each  do |r|
            region=region <<","<< r.name
          end
        end
      end
      if user_type.include?"GBL"
        if region.present? && region !='null'
          if region.include? "All"
          else
            filter= filter << " and region = ANY (regexp_split_to_array('" << region <<"', '\,'))"
          end
        end
        @users_list =User.get_users_by_state( @state,"admin",current_user,filter)
      else
        if region =='null'
          region= current_user.region
          if region.include? "Default"
            available_regions = current_user.available_regions;
            available_regions.each  do |r|
              region=region <<","<< r.name
            end
          end
        end
        if region.include? "All"
        else
          filter= filter << " and region = ANY (regexp_split_to_array('" << region <<"', '\,'))"
        end
        @users_list =User.get_users_by_state( @state,"manager",current_user,filter)
      end
  
  render json: {
    status: 200,
    count: @users_list.count().to_s
 }.to_json
 end

    def request_state  #get profiles of the users by state
      filter=""
      age_from = params[:age_from]
      age_to = params[:age_to]
      gender = params[:gender]
      region = params[:region]
      name = params[:name]
     
      profile_state = params[:profile_state]
      user_type=UserRole.get_roles(current_user)
      managers_list =  ActiveRecord::Base.connection.execute('select users.first_name,users.last_name,users.region from users join user_roles on users.id=user_roles.user_id where user_roles.role_id=2')
      if(!profile_state.present? && profile_state !='null' )
        filter= filter << " and p.profile_state='" << profile_state <<"'"
      end
      if(age_from.present? && age_from !='null' )
        filter= filter << ' and EXTRACT(YEAR FROM age(p.dob)) >=' << age_from
      end
      if(age_to.present? && age_to !='null' )
        filter= filter << ' and EXTRACT(YEAR FROM age(p.dob)) <=' << age_to
      end
      if(gender.present? && gender !='null' )
        filter= filter << " and LOWER(p.gender)='" << gender <<"'"
      end
      # if(region.present? && region !='null' )
      #   filter= filter << " and u.region='" << region <<"'"
      # end
      if(profile_state.present? && profile_state !='null' )
        filter= filter << " and p.profile_state='" << profile_state <<"'"
      end
      if(name.present? && name !='null' )
        name = name.downcase
        split_name = name.split(' ')
        filter= filter << " and LOWER(u.first_name) LIKE '%" << split_name[0] <<"%'"
        filter= filter << " or LOWER(u.last_name) LIKE '%" << split_name[0] <<"%'"
        if split_name[1].present?
          filter= filter << " or LOWER(u.last_name) LIKE '%" << split_name[1] <<"%'"
          filter= filter << " or LOWER(u.first_name) LIKE '%" << split_name[1] <<"%'"
        end
      end
      
      @state = params[:state]
      if region.present? && region !='null'
        if region.include? "Default"
          available_regions = current_user.available_regions;
          available_regions.each  do |r|
            region=region <<","<< r.name
          end
        end
      end
      if user_type.include?"GBL"
        if region.present? && region !='null'
          if region.include? "All"
          else
            filter= filter << " and region = ANY (regexp_split_to_array('" << region <<"', '\,'))"
          end
         
        end
        
        @users_list =User.get_users_by_state( @state,"admin",current_user,filter)
      else
        if region =='null'
          region= current_user.region
          if region.include? "Default"
            available_regions = current_user.available_regions;
            available_regions.each  do |r|
              region=region <<","<< r.name
            end
          end
        end
        if region.include? "All"
        else
          filter= filter << " and region = ANY (regexp_split_to_array('" << region <<"', '\,'))"
        end
       
        @users_list =User.get_users_by_state( @state,"manager",current_user,filter)
      end
      
      render json: {
        status: 200,
        message: true,
        users:@users_list.to_a,
        current_user_region:current_user.region,
        managers: managers_list.to_a
     }.to_json
    end

    def export_user_list
      user_list=[]
      if(UserRole.get_roles(current_user).include?('GBL'))
        user_list=User.get_members.joins(:member).where('(members.export_request_on is not ? AND members.export_accepted_on is NULL) OR members.export_accepted_on <=members.export_request_on',nil)
      else
        #To get list of regions under  regional manager
        region_list=current_user.region.split(", ")   
        user_list=User.get_members.joins(:member).where('(members.export_request_on is not ? AND members.export_accepted_on is NULL)  OR members.export_accepted_on <=members.export_request_on and users.region in (?)',nil,region_list)
      end
      render json: {
        status: 200,
        userList:user_list,
        count: user_list.count
     }.to_json
    end

    def get_regional_managers
     managers= User.joins(:user_roles).where('user_roles.role_id=?',2)
      render json: {
        status: 200,
        message: true,
        managers: managers.includes(:profile),
      }.to_json
    end
  
    def inbox
      @class_all= @class_sent=@class_recev=@class_other=""
      @subject = params[:subject]
      @box_type = params[:box_type]
      page=params[:page].present? ? params[:page] : 1
      
      #conversations =helpers.mailboxer_list(@mailbox, @subject,page,10,@box_type)
      conversations = @mailbox.conversations.where.not(:subject => "Need more information").paginate(page: page, per_page: 10)
      
      inbox=[]
      messages_list=[]
      conversations.each do |i|
      
      user_type=i.receipts.where.not(:receiver_id => current_user.id).first
      if user_type.present?

      
        user_model = User.find(user_type.receiver_id)

        user_type=user_model.position
        
        item=Hash.new
        item[:message]=i.messages.last.body
        item[:conv_id]=i.id
        item[:new]=i.is_unread?(current_user)
        item[:subject]=i.subject
        item[:time]=i.created_at
        item[:mailbox_type]=i.receipts.where(:receiver_id => current_user.id).first.mailbox_type
        if item[:mailbox_type] == "sentbox" 
          item[:subject]="You sent message"
        end
        item[:receiver_name]=i.receipts.reject { |p| p.receiver.id == current_user.id }.collect {|p| ("#{p.receiver.first_name} #{p.receiver.last_name }")}.uniq.join(" ,")
        
        if (user_type=='Manager') &&  @subject== "Manager message" && i.participants.size>1
        messages_list.push(item)
       elsif (user_type=='Admin') &&  @subject== "Manager message" && i.participants.size>1
        messages_list.push(item)
        
      elsif (user_type=='Member') &&  (@subject== "Member message") && i.participants.size>1
        messages_list.push(item)
        end
      end
    end
              
      render json: {
        status: 200,
        conversations:  messages_list.paginate(:page =>  page, :per_page => 10),
        total: messages_list.count
     }.to_json
    end

    def conversation
      @conversation = @mailbox.conversations.find(params[:id])
      @conversation.mark_as_read(current_user)
      @message = Mailboxer::Message.new
    end

    def generate_report
     
      if params[:id].present?
        userInfo= User.find params[:id]
        reportFile=  ReportPdf.new(userInfo)
        save_path = Rails.root.join('app','assets','pdfs','rep.pdf')
        reportFile.render_file(save_path)
       if userInfo.member.present?
          userInfo.member.update(export_accepted_on:Time.now)
          MilanMailer.export_invoice(userInfo,save_path.to_s).deliver_now
          render json:{ message: "Attachment sent successfully"}
       end
      else
          render json: {status: "error", code: 422, message: "User doesn't exist"}
      end
     end
    
 
private

def member_delete(action,receiver)
  recipients= receiver
      case action
      when "deactivate"
        @user.deactivate!
        flash[:alert]=t('.member_deactivate')
        @comment= helpers.is_super_admin? ? t('.gbl_deactivate'): t('.rgn_deactivate')
      when "reactivate"
        @user.reactivate!
        flash[:alert]=t('.member_reactivate')
        @comment=helpers.is_super_admin? ? t('.gbl_reactivate'):t('.rgn_reactivate')
      when "delete_account"
        @user.delete_account!
        flash[:alert]=t('.member_delete')
        @comment=helpers.is_super_admin?  ? t('.gbl_delete'):t('.rgn_delete')
      else
        flash[:alert]=t('.wrong')
      end
      current_user.send_message(recipients,@comment,"User status").conversation
  end


def inbox_mail(state)
  if @message_box.eql? "all"
    @class_all = "active"
    @sentbox = helpers.mailboxer_list(@mailbox,t('.sent_invite'),params[:page],10,"sentbox")
  elsif @message_box.eql? nil
    @class_all = "active"
  elsif @message_box.eql? "from_members"
    @class_recev = "active"
  elsif @message_box.eql? "from_managers"
    @class_sent="active"
    @conversations = helpers.mailboxer_list(@mailbox,t('.connect_invite'),params[:page],10,"sentbox") 
  else
   @class_other="active"
   @subject= "#{t('.connect_invite')};#{t('.sent_invite')}"
   @conversations =helpers.mailboxer_list(@mailbox,@subject,params[:page],10,"others")
  end
end


def profile_count 
  @all_count = User.get_users_by_state("all","admin",current_user,"").count().to_s
  @new_count = User.get_users_by_state("new_requests","admin",current_user,"").count().to_s
  @in_review_count = User.get_users_by_state("in_review","admin",current_user,"").count().to_s
  @active_count =User.get_users_by_state("current","admin",current_user,"").count() 
  @deactivate_count = User.get_users_by_state("deactivated","admin",current_user,"").count() 
end




def search_filter
  params.permit(:gender, :age, :request,:term,:page)
end
def sign_up_params
  params.require(:user).permit(:email, :password,  :first_name, :last_name, :region)
end
def profile_for_params
  params.require(:profile_for).permit(:role_id)
end
def userparam
    params.require(:user).permit(:first_name, :last_name, :middlename, :password,:id, :email,region:[])
end
def workflowparams
  params.require(:WorkflowStatus).permit(:id, :module, :user_id, :comment)
end
def get_mailbox
  
  @mailbox ||= current_user.mailbox
  @unreadmsg=@mailbox.inbox(:read => false).count(:id).to_s
 end
 def get_conversation
  @conversation ||= @mailbox.conversations.find(params[:id])
end


end