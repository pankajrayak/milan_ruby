class MilanMailer < ApplicationMailer
     def inform_regional(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.new_profile'))
     end

     def inform_admin(admin,user)
        @user=admin
        @member=user
        mail(to: admin.email, subject: I18n.t('milan.subject.inform_admin'))
        puts ' Message sent '
     end

     def expire(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.expiration'))
     end

     def email_confirmations(user,type)
        @user=user
        @type=type
        mail(to: user.email, subject: 'Confirmation instructions From Milan')
     end

     def match(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.match'))
     end

     def more_info(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.more_info'))
     end
     def new_connection(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.con_request'))
     end
     def notify_regional(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.more_info'))
     end
     def profile_rejected(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.reject'))
     end
     def received_msg(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.msg'))
     end
     def reminder(user,url)
        @url=url
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.reminder'))
     end
     def respond_connection(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.con_respond'))
     end
     def user_approved(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.approve'))
     end
    #  def export_gdpr_mail(user)
    #     @user=user
    #     mail(to: user.email, subject: I18n.t('milan.subject.export_sub'))
    #  end
     def export_invoice(partner,file)
            @user = partner
            attachments["export.pdf"] = File.read(file)
            mail :to => partner.email, :subject => I18n.t('milan.subject.export_sub')
     end
     def profile_deactivated(user,performed_by)
        @user=user
        @performed_by=performed_by
        mail(to: user.email, subject: I18n.t('milan.subject.deactivated'))
     end

     def profile_activated(user)
        @user=user
        mail(to: user.email, subject: I18n.t('milan.subject.activated'))
     end
end
