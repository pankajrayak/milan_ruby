class PartnerPreference < ApplicationRecord
    belongs_to :user
    has_one :deal_breaker,dependent: :destroy
    after_update_commit :user_matches
    #deletes profile matches and creates new matches for user
    def user_matches
        user = User.find self.user_id
        exclude_ids=[]
        sentConnections = Interest.where(:user_to=> self.user_id).to_a
        recConnections = Interest.where(:user_id=> self.user_id).to_a
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
            ProfileMatch.delete_matches(self.user_id)
            ProfileMatch.create_matches(self.user_id,exclude_ids)
        end
    end

    # def as_json(options={})
        
    #       include: [:deal_breaker]  
    #       super(options).merge({
    #   end
end
