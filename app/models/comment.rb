class Comment < ApplicationRecord
    after_create_commit { create_event }
#recent activiy
    def create_event
        Activity.create(user_id:58,action:'follower',notifiable_type:'User')
     end
end
