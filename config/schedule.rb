# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
set :output, {error: "log/cron-error.log", standard: "shared/log/cron.log"}
set :output, "shared/log/cron_log.log"
ENV.each { |k, v| env(k, v) }

     every 1.day, at: '10:00 pm' do
         rake 'add_profile_match'
     end
   
    # every 1.day,  at: '9:00 am' do
    #     runner 'LogMailer.send_log_file.deliver'
    # end
    every :day, at:'11pm' do
        rake 'expire_inform_user'
    end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
