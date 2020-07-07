module ApplicationHelper
  include ActionView::Helpers::UrlHelper
  include CustomMethods
    #user_to is treated as recipient/interest id on condition based
    def user_interests(user_to,action,message) 
         
        @interest = Interest.new
        @sender="#{current_user.first_name} #{current_user.last_name}"
        body=message
        if action =='request'
          ProfileMatch.where(user_id:current_user.id,match_user_id:user_to).or(ProfileMatch.where(user_id:user_to,match_user_id:current_user.id)).delete_all
          recipient=User.find_by_id user_to
          subject=I18n.t('admin.inbox.connect_invite')
          msg=  I18n.t('interest.request', name: @sender) 
          body= body.blank? ? msg : body
          MilanMailer.new_connection(recipient).deliver_later
          @interest = Interest.select(Arel.star).where(
            Interest.arel_table[:user_id].eq(user_to).and(Interest.arel_table[:user_to].eq(current_user.id)).or(
              Interest.arel_table[:user_id].eq(current_user.id).and(Interest.arel_table[:user_to].eq(user_to))
            )
          )
          if @interest.present?
            @interest.destroy_all
          end
          @message = current_user.send_message(recipient,body,subject).conversation
          Interest.create({user_to:user_to,user_id:current_user.id,conv_id:@message.id})
        elsif(action!='message')
          @interest = Interest.find_by_id(user_to)
          recipient=  @interest.user_to ==current_user.id ? User.find_by_id(@interest.user_id) :  User.find_by_id(@interest.user_to)
        case action
              when 'accepted'
                @interest.accept!
                MilanMailer.respond_connection(recipient).deliver_later
                subject=I18n.t('interest.accept', name: @sender) 
              when 'rejected'
                @interest.reject!
                subject=I18n.t('interest.reject', name: @sender) 
              when 'canceled'
                @interest.reject!
                subject=I18n.t('interest.cancle', name: @sender) 
              when 'not_interested'
                @interest.close_connection!
                subject=I18n.t('interest.close', name: @sender) 
              when 'report'
                @interest.report_connection!
                subject=I18n.t('interest.report', name: @sender)
                body="Reported email: #{recipient.email} \n "+ body #here recipient.email describes reported user  
                #recipient=User.joins(:user_roles).where('user_roles.role_id = ? AND users.region= ?',2,current_user.region)
                recipient=User.get_user_manager_only(current_user.region)
              end
        end
      
        if action !='request'
          @message = current_user.send_message(recipient,body,subject).conversation
        end
    end

      #check for admin
      #returns true/false
      def is_admin(user_id)
         @user=User.find_by_id(user_id)
        if Profile.privilige(current_user, @user)
          true
        else
          false   
         end
      end

      def age(dob)
        now = Time.now.utc.to_date
        now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
      end

      def ageOptions()
          @age_list=  []
          [20,24,30,35,40,42,48,55].each do |i|
            a = Date.tomorrow
            year = ( a.year - i ) - 1
            month = a.mon
            day = a.mday
            @age_list.push( {value:Date.new(year,month,day),name: i})
          end
          @age_list
      end

      # User Profile states handling
      def states_handling(object,task,msg_body) 
        user_model=User.new
        user_model=User.find current_user.present? ? current_user.id : session[:milan_user] #user_model contain latest record changes
        user_type=user_model.position
        recipients=object.user
        page_link=(link_to 'View Profile', "#{ENV['FRONTEND_URL']}myprofile/#{object.user_id}" , target: :_blank)
        body=""
      if(user_type=="Admin")
        body=CustomMethods.admin_statement(task,user_model,page_link)
        subject=I18n.t("prompt.admin.#{object.profile_state}")
      elsif (user_type=='Manager')
        body=CustomMethods.manager_statement(task,user_model,page_link)
        subject=I18n.t("prompt.manager.#{object.profile_state}")
      elsif (user_type=='Member')
         body=CustomMethods.member_statement(task,user_model,page_link)
         recipients=User.get_user_manager(user_model.region)
         if !recipients.present? || user_model.region=="Default"
          recipients=User.get_admin()
         end
         subject=I18n.t('prompt.msg_user')
      end
      
        workflow_msg=msg_body.present? ? msg_body : body
        WorkflowStatus.regional_admin_workflow(workflow_msg,'profile',object.current_state.name,object.user_id)
        #body= body + ' <br/> ' + (task == 'new'? '' : msg_body)
        if !["deleted","deactivated"].include? user_model.state
          Notification.send_notifitaion(user_model.id,object.user_id,task,subject)
        end
        if (user_type=='Member') && (task=='new')
          #Do if new profile is created and user is Member
        else
          user_model.send_message(recipients,body,subject).conversation
        end

        
      end


    def mailboxer_list(mails,subject,page,size,box_type)
      conversations=nil
      
      if(box_type==='inbox')
        if subject.present?
          conversations= mails.inbox.where(:subject => subject).where.not(:subject => "Need more information").paginate(page: page, per_page: size)
        else
          conversations= mails.inbox.where.not(:subject => "Need more information").paginate(page: page, per_page: size)
        end
      elsif(box_type==='sentbox')
         if subject.present?
          conversations= mails.sentbox.where.not(:subject => "Need more information").where(:subject => subject).paginate(page: page, per_page: size)
         else
          conversations= mails.sentbox.where.not(:subject => "Need more information").paginate(page: page, per_page: size)
         end
      elsif(box_type==='others')
           if subject.present?
            conversations=mails.conversations({:mailbox_type => 'not_trash'}).where.not(:subject => "Need more information").where.not(subject: subject).paginate(page: page, per_page: size)
            end
      elsif(box_type==='all')
        conversations= mails.conversations({:mailbox_type => 'not_trash'}).where.not(:subject => "Need more information")
        end
      end



def mail_from_admin(object,workflow)  #sending changes made by admin to user
  @comment="#{current_user.first_name}  has updated your profile #{workflow.state}:  #{workflow.comment}"
  @replytoconversation= current_user.mailbox.conversations.participant(User.find_by_id object.user.id).last
  if !@replytoconversation.nil?
   current_user.reply_to_conversation(@replytoconversation,@comment)
  end
end

   
   def is_super_admin
        role_list=UserRole.get_roles(current_user)
        superadmin=role_list.include?('GBL')
   end


   


 end
