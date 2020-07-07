class Profile < ApplicationRecord
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  has_paper_trail
  belongs_to :user 
  has_many :workflow_statuses
  
  #filters
  scope :age_filter, -> (start,ends) { where("  extract(year from dob) > ? AND extract(year from dob) < ? ",Time.now.year-start,Time.now.year-ends)}
  scope :height_filter, -> (start,ends) { where(" height > ? AND height < ? ",start,ends)}
  scope :marital_filter, -> (name) { where("marital_status like ?", name)}
  scope :community_filter, -> (name) { where community: name }
  scope :children_filter, -> (name) { where have_children: name }
  scope :status_filter, ->(name) {where profile_state:name}
  scope :id_filter, ->(ids){where.not user_id:ids}
  scope :remove_expired, ->{where.not user_id: User.expired_user_ids}
  scope :opposite_sex, ->(name){where gender: (name=='Male')? "Female" : "Male"}
  scope :country_filter, ->(name){where country: name}
  scope :state_filter, ->(name){where state: name}
  def self.privilige(current,user)
     role= UserRole.get_roles(current)
    if ((role.include?'RGN')  && ( current.region == user.region )) || (role.include?'GBL')
      true
    else
      false
    end
  end
  #workflow state
  include Workflow
  workflow_column :profile_state
  workflow do
    state :new do
     # event :submit, :transitions_to => :awaiting_review
      event :need_more_info, :transitions_to => :being_reviewed
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :being_reviewed do
      event :response_to_request, :transitions_to=> :awaiting_review
      # event :need_more_info, :transitions_to => :new
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :awaiting_review do
      # event :review, :transitions_to => :being_reviewed
      event :need_more_info, :transitions_to => :being_reviewed
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :rejected do
      event :accept, :transitions_to => :accepted
    end
    state :accepted do
      event :reject, :transitions_to => :rejected
    end
    state :need_more_info
    #state :accepted 
   # state :rejected
  end

  #filtering
scope :old_request, ->{ where state:'awaiting_review'}
scope :new_request, ->{ where state:'being_reviewed'}
scope :user_gender, ->(gender){where gender: gender if gender.present?}

 
  #validation 
 validates_presence_of :gender, :country
 validates :dob, presence:true
 validate  :adult_only

 def adult_only
   if dob.present? && (dob.to_date + 18.years) > Date.today
    errors.add(:dob, "Only 18+ Users allowed")
   end
 end

  def self.change_state(new_state,value,action_by)
  case new_state
  when "Approve Member" then
    value.accept!
    MilanMailer.user_approved(value.user).deliver_later
    ProfileMatch.create_matches(value.user_id,[])
    photos = Photo.where(:user_id=>value.user_id)
    photos.each do |photo| 
      if photo.workflow_state=='new'
        photo.accept!
      end
    end
  when "Reject Membership" then
    value.reject!
    MilanMailer.profile_rejected(value.user).deliver_later
    value.user.deactivate!
  when "Report Spam" then
    value.reject!
    value.user.deactivate!
    ProfileMatch.delete_other_user_matches(value.user_id)
    ProfileMatch.delete_matches(value.user_id)
  when "Request Information" then
    value.need_more_info!
    MilanMailer.more_info(value.user).deliver_later
  when "Deactivate Member" then
    value.user.deactivate!
    value.reject!
    ProfileMatch.delete_other_user_matches(value.user_id)
    ProfileMatch.delete_matches(value.user_id)
    MilanMailer.profile_deactivated(value.user,action_by).deliver_later
  when "Report Member" then
    value.reject!
    value.user.deactivate!
    ProfileMatch.delete_other_user_matches(value.user_id)
    ProfileMatch.delete_matches(value.user_id)
  when "Member Response" then
    value.response_to_request!
    recipients=User.get_user_manager(value.user.region)
    recipients.each do |recipient|
      MilanMailer.notify_regional(recipient).deliver_later
    end
  when "Activate Member" then
     if value != "accepted"
      value.accept!
     end
    ProfileMatch.create_matches(value.user_id,[])
    value.user.reactivate!
    MilanMailer.profile_activated(value.user).deliver_later
  end
  User.update_elastic(value.user)
  value
end


def self.manager_profile(user)

  user.create_profile(
    gender: Faker::Gender.binary_type,
    about_me:  Faker::HowIMetYourMother.quote,
    facebook: 'www.facebook.com/user/profile/'+user.first_name,
    instagram:'www.instagram.com/user/profile/'+user.first_name,
    country:  Faker::Address.country,
    member_relationship: "Self",
    marital_status: "",
    community:'',
    education_level: "",
    have_children: 'No',
    state: Faker::Address.state,
    city: Faker::Address.city,
    height: 160,
    mobile_number: Faker::PhoneNumber.cell_phone,
    phone_number:Faker::PhoneNumber.phone_number,
    dob:  Faker::Date.birthday(18, 65),
    diet: "vegetarian",
    smoke: 'Yes' ,
    drink: 'Yes',
    is_manglik: true,
    values: 'values',
    profile_state: 'accepted'
    )
end


end
