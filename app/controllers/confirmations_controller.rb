class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
    include ActionView::Helpers::UrlHelper
    include CustomMethods
    def show
        super do |resource|
            page_link=(link_to 'View Profile', "#{ENV['FRONTEND_URL']}myprofile/#{resource.id}" , target: :_blank)
            recipients=User.get_user_manager(resource.region).first
            body=CustomMethods.member_statement("new",resource,page_link)
            subject=I18n.t('prompt.msg_user')
            if !recipients.present? || resource.region=="Default"
                recipients=User.get_admin()
                MilanMailer.inform_regional(recipients).deliver_later 
            else
                MilanMailer.inform_regional(recipients).deliver_later 
            end
            resource.send_message(recipients,body,subject).conversation        
            resource.mailbox.sentbox.last.move_to_trash(resource)
        end

    end
end
