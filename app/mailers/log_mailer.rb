class LogMailer < ApplicationMailer
    default to:  ["atul@ziggletech.com"]
    layout "mailer"
    def send_log_file
        attachments["logfile.txt"] = File.read("#{Rails.root}/log/production.log")
        mail(subject: "Log File")
     end
end
