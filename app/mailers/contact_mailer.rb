class ContactMailer < ApplicationMailer
   def contact_email(user,message)
         @name=user
        @message=OpenStruct.new(message)
        mail(to: @message.to, from:'milan@agsa.co', subject: 'Query Portal')
      end
end
