class ExpirationNotifierJob < ApplicationJob
  queue_as :default

  def perform(user)
    puts 'Send Reminder to user'
    id=UserRole.where(role_id:3).pluck(:id)
    admin=User.find_by(id:id) 
    message_mail=""
    subject=I18n.t('expire.subject')

    days_left=Time.at(user.expiration_date - Time.now).day
    case days_left
    when 60
      message_mail=I18n.t('expire.two_month')
    when 30
      message_mail=I18n.t('expire.one_month')
    when 1
      message_mail=I18n.t('expire.one_day')
    else
     puts "Dont send mail"
    end   
    if message_mail.present?
    admin.send_message(user,message_mail,subject)
    MilanMailer.expire(user).deliver_later
    end
    
  end
end
