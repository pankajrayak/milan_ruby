desc 'expire inform user'
task expire_inform_user: :environment do

    #message sent from admin with roles(1,2,3)

    User.where.not(id: User.manager_and_admin_ids).find_in_batches do |group|
        group.each do |user|
            if user.expiration_date.present?
                ExpirationNotifierJob.perform_later user
            end
        end
    end
end