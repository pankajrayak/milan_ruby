class ApplicationMailer < ActionMailer::Base
  default from: 'milan@agsa.co'
  layout 'mailer'
  add_template_helper(SignatureHelper)
end
