
namespace :milan do
    desc "Sends Message to Admin if regional manager does not take an action on new membership request for more than a week"

    task inform_admin: :environment  do
        # admin <=  one/multiple admin
    admin= User.where(id: User.joins(:user_roles).where('user_roles.role_id=?',3)).first
   User.get_members.paid_user.find_in_batches do |group|
        group.each do |user|
            more_than_week= Time.now.to_date - user.profile.updated_at.to_date
            puts  "Profile Status: "+ user.profile.profile_state + '\n' 
            member= Member.find_by_user_id user.id
            user_new = User.find user.id
            if member.present?
                if ((user.profile.profile_state.eql? 'new') && (more_than_week.to_i >= 7) && (member.inform_admin))
                    MilanMailer.inform_admin(admin,user_new).deliver_now
                    puts ' Member Status: '+member.inform_admin.to_s
                    if member.present?
                    member.inform_admin=false
                    member.save
                    end
                end
            end
        end
    end
   
   
    end
end
