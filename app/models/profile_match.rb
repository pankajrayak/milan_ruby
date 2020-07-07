class ProfileMatch < ApplicationRecord
  belongs_to :user
   # attr_accessor :user_id, :match_user_id, :match_sent_on
    def self.matched_user(id)
    @sql="select db.age as db_age,db.height as db_height,db.marital_status as db_marital_status,db.community as db_community,db.have_children as db_have_children,db.country as db_country,pp.age_from,pp.age_to,pp.height_from,pp.height_to,pp.marital_status as partner_marital_status, pp.have_children as partner_have_children, pp.community as partner_community,pp.country as partner_country, p_m.match_user_id as user_id,pr.id as profile_id,pr.facebook,pr.linkedin,pr.instagram,pr.values,pr.marital_status,pr.country,
    pr.dob,pr.time_of_birth, pr.city_of_birth, pr.state_of_birth, pr.country_of_birth,pr.photo,pr.gender,u.email,u.first_name, u.last_name,pr.city,pr.state,pr.diet,pr.is_manglik,pr.occupation,pr.education_concentration,pr.nakshatra,pr.religion,  u.region,ph.private_pic,pr.have_children,pr.height,pr.about_me, pr.education_level,
     ph.url from profile_matches p_m inner join users u on p_m.match_user_id=u.id left join photos ph on u.id=ph.user_id
     inner join partner_preferences pp on pp.user_id=u.id inner join deal_breakers db on db.partner_preference_id=pp.id inner join profiles pr on pr.user_id=p_m.match_user_id where  p_m.user_id=#{id} and pr.profile_state='accepted' and
      ph.photo_for like 'headshot' "
    #@sql="select * from users join profiles on profiles.user_id = users.id"
    profile_list=[] 
    profile_list=ActiveRecord::Base.connection.execute(@sql)
    profile_list.to_a
    end
    def self.remove_from_match(user_id,match_id)
      ProfileMatch.where(user_id: user_id, match_user_id: match_id).or(ProfileMatch.where(user_id: match_id, match_user_id: user_id)).destroy_all
    end

  def self.delete_matches(id)
    ProfileMatch.where(:user_id => id).destroy_all
  end
  def self.delete_other_user_matches(id)
    ProfileMatch.where(:match_user_id => id).destroy_all
  end

    def self.create_matches(id,exclude_id)
      user_info=User.find_by(id: id)
      selected_deals=  user_info.partner_preference.deal_breaker if user_info.partner_preference.present?
      preference= user_info.partner_preference
      @profiles=Profile.remove_expired
      create_records=[]   
      if user_info.profile.present?
      @profiles=@profiles.opposite_sex(user_info.profile.gender)
      if preference.present? && selected_deals.present?
      exclude_id+=ProfileMatch.where(user_id: id).select(:match_user_id).pluck(:match_user_id)
      exclude_id+=Interest.received(id).pluck(:user_id) + Interest.sent(id).pluck(:user_to)
      @profiles = @profiles.id_filter( User.manager_and_admin_ids + exclude_id + [id] )
      @profiles = @profiles.age_filter(preference.age_to,preference.age_from) if selected_deals.age.present?
      @profiles = @profiles.height_filter(preference.height_from,preference.height_to) if selected_deals.height.present?
      @profiles = @profiles.marital_filter(preference.marital_status) if selected_deals.marital_status.present?
      @profiles = @profiles.community_filter(preference.community) if selected_deals.community.present?
      @profiles = @profiles.children_filter(preference.have_children) if selected_deals.have_children.present?
      @profiles = @profiles.country_filter(preference.country) if selected_deals.country.present?
      @profiles = @profiles.state_filter(preference.state) if selected_deals.state.present?
      @profiles = @profiles.status_filter('accepted')
      end
    #  @profiles =  @profiles.id_filter(exclude_id + [id]) 
      list=@profiles.take(5).pluck('user_id')
        list.each do |i|
            create_records.push({:user_id=>id, :match_user_id=>i, :match_sent_on=>Time.now})
        end
        ProfileMatch.create(create_records)
    end
    create_records
  end
  
end
