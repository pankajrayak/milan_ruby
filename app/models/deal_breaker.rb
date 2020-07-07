class DealBreaker < ApplicationRecord
    has_paper_trail
    after_update_commit :user_matches
    def user_matches
       partner_record=PartnerPreference.find_by(id: self.partner_preference_id)
       user = User.find partner_record.user_id

       
       exclude_ids=[]
       sentConnections = Interest.where(:user_to=> partner_record.user_id).to_a
       recConnections = Interest.where(:user_id=> partner_record.user_id).to_a
       sentConnections.each do |s|
        if s.state=="awaiting_response" || s.state=="accepted"
           exclude_ids.push(s.user_id)
        end
       end
       recConnections.each do |r|
        if r.state=="awaiting_response" || r.state=="accepted"
           exclude_ids.push(r.user_to)
        end
       end
       if user.profile.profile_state=='accepted'
        ProfileMatch.delete_matches(partner_record.user_id)
        ProfileMatch.create_matches(partner_record.user_id,exclude_ids)
       end
    end
end
