class UserRole < ApplicationRecord
has_paper_trail
belongs_to :user
belongs_to :role
 #fetch all roles for user
def self.get_roles(user)
    user.user_roles.joins(:role).pluck(:role) 
end


def self.my_regional_admin(user,region)
    user_role=UserRole.get_roles(user)
    if user_role.include?'GBL'
        return true
    elsif user_role.include?'RGN'
    return (user.region.split(',').include?(region))
    else
        return false
    end
end
end
