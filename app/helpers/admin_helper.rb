module AdminHelper
    def all_profile(state)
       
    end
    def counts_list()
        @conversations = @mailbox.inbox.first(10)
        @all_count = User.get_users_by_state("all","admin",current_user,"").count().to_s
        @new_count = User.get_users_by_state("new_requests","admin",current_user,"").count().to_s
        @in_review_count = User.get_users_by_state("in_review","admin",current_user,"").count().to_s
        @active_count =User.get_users_by_state("current","admin",current_user,"").count() 
        @deactivate_count = User.get_users_by_state("deactivated","admin",current_user,"").count() 
    end
    def all_new_profile()
        # @all_count = Profile.where(:profile_state => "awaiting_review").or(Profile.where(:profile_state => "new")).count(:id).to_s
        # if current_user.admin=="RGN"
        #     @allcount =User.get_users_by_state("awaiting_review","admin",current_user).count().to_s
        # end
    end
end
