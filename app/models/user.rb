class User < ApplicationRecord
 
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable   #, :omniauthable  #,:token_authenticatable
  include DeviseTokenAuth::Concerns::User

 # include PolicyManager::Concerns::UserBehavior  #policy management
  
  acts_as_messageable # Model used for messaging 
  has_paper_trail
  has_one :profile, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :profile_matches, dependent: :destroy
  has_many :interests, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :workflow_statuses, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :profile_matches, dependent: :destroy
  has_many :billing_addresses, dependent: :destroy
  accepts_nested_attributes_for :photos
  has_one :partner_preference, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :roles
  has_many :customer_cards, dependent: :destroy
  has_one :member, dependent: :destroy
  
  include Searchable
  before_destroy :all_linked_user
  scope :expired_user_ids, ->{where("expiration_date < ?",Time.now ).pluck(:id)}
  scope :paid_user, ->{where("expiration_date > ?",Time.now )}
  def as_indexed_json(options={})
    as_json(
      include: [:profile,:user_roles,:photos,:partner_preference=> {include: [:deal_breaker]}]  
    )
  end

# overridden devise json extended details after signin for roles
  def as_json(options={}) 
    user_tbl=User.find_by id:super["id"]
    if user_tbl.present?
      super(options).merge({role: user_tbl.user_roles.joins(:role).pluck(:role),profiles: user_tbl.profile,photos: user_tbl.photos})
    end
  end

  #user attached records for deletion
  def all_linked_user
    id=self.id
    user = User.find self.id
    convs= user.mailbox.conversations
    if convs.present?
      convs.destroy_all
    end
    ProfileMatch.where(match_user_id: id).destroy_all
    Notification.where(recipient_id: id).destroy_all
    Interest.where(user_to: id).destroy_all
  end

  #Workflow state
  include Workflow
  workflow_column :state
  workflow do
    state :active do
      event :deactivate, :transitions_to => :deactivated
      event :delete_account, :transitions_to => :deleted
    end
    state :deactivated do
      event :reactivate, :transitions_to => :active
      event :delete_account, :transitions_to => :deleted
    end
    state :deleted do
      event :reactivate, :transitions_to => :active
    end
  end

  #user position in milan
  def position 
    roles=UserRole.get_roles(self)
    user_level='Member'
    if roles.include?('GBL')
      user_level='Admin'
    elsif roles.include?('RGN')
      user_level='Manager'
    end
    user_level
  end 

  def build_auth_url(base_url, args)
    args[:uid]    = uid
    #we don't need expiry because we are not logging usre automatically
    #args[:expiry] = tokens[args[:client_id]]['expiry']
    DeviseTokenAuth::Url.generate(base_url, args)
  end
  #validation
  validate :password_complexity
  validates :first_name, :length=> {:maximum => 40,
    :too_long => "%{count} characters is the maximum limit" }
  validates :last_name, :length=> {:maximum => 40,
    :too_long => "%{count} characters is the limit" }

   
  def password_complexity
    if password.present?
       if !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*()])(?=.{8,})/) 
         errors.add :password, "Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character"
       end
    end
  end

  def name
    email
  end


  def active_for_authentication?
      account_active?
  end
  #handling message for deactivate and confirmation user
  def account_active?
    self.state==='deactivated'|| !self.confirmed? ? false : true
  end


 # for updating elastic search record
  def self.update_elastic(obj)
    obj.__elasticsearch__.index_document
  end

  def self.extend_date(user,no_of_year)
    user.expiration_date=(  user.expiration_date!=nil ? user.expiration_date + no_of_year.year : Time.now + no_of_year.year)
    user.save
  end

  def self.manager_and_admin_ids
    User.where(id: User.joins(:user_roles).where(:user_roles=>{role_id:2}).pluck(:user_id) + User.joins(:user_roles).where(:user_roles=>{role_id:3}).pluck(:user_id)).pluck(:id)
  end

  def self.manager_ids
    User.where(id: User.joins(:user_roles).where('user_roles.role_id=? AND user_roles.role_id !=?',2,3).pluck(:user_id) ).pluck(:id)
  end

  def mailboxer_email(object)
    email
  end

  def available_regions
     all_manager= User.manager_ids
     all_manager.delete(self.id) 
    region_occupied=User.where(id:all_manager).pluck(:region)
    region_occupied_list=[]
    if region_occupied.size / 2 == 1
      region_occupied_list=region_occupied.to_sentence.gsub(" and",",").gsub(", ",",").split(',').map(&:to_s)
    else
    region_occupied_list=region_occupied.to_sentence.gsub("and ","").gsub(", ",",").split(',').map(&:to_s)
    end
    Region.where.not(name:region_occupied_list)
  end

  def self.email_exist(email)
    User.exists?(email: email)
  end


  def self.get_user_manager(region)
    User.joins(:user_roles).where(["users.region LIKE ? AND user_roles.role_id=? AND user_roles.role_id !=?","%#{region}%",2,3])

   end

   def get_admin_and_manager
    User.joins(:user_roles).where(["(users.region LIKE ? AND user_roles.role_id=2) OR user_roles.role_id =?","%#{self.region}%",3])

   end

   def self.get_admin()
    User.joins(:user_roles).where(["users.confirmed_at is not null AND user_roles.role_id =?",3])

   end

   def self.get_user_manager_only(region)
    managers = ActiveRecord::Base.connection.execute("select u.id from users u join user_roles ur on ur.user_id=u.id where ur.role_id=2  and '#{region}'=ANY (regexp_split_to_array(u.region, '\,'))")
    user = User.find(managers.values[0][0])
   end
   def self.get_members
    User.joins(:user_roles).where(["user_roles.role_id != ? AND user_roles.role_id != ?",3,2])
   end

  def self.get_users_by_state(state,role,current_user,filter)
    if( UserRole.get_roles(current_user).include?'GBL')
      #@sql = "select u.first_name, u.last_name,p.profile_state, u.region, ur.role_id,(select first_name from users as us inner join user_roles u_r on u_r.user_id=us.id where u_r.role_id=2 and us.region=u.region limit 1) as manager from users u inner join user_roles ur on u.id=ur.user_id  join profiles as p on p.user_id = u.id and ur.role_id <>3 where u.id>0"
      @sql="select p.gender,u.region,TO_CHAR(p.created_at :: DATE, 'mm-dd-yyyy') as date,u.first_name || ' ' || u.last_name as name,u.id user_id,p.id as profile_id,u.first_name,u.last_name,CASE profile_state WHEN 'new' THEN 'New' WHEN 'awaiting_review' THEN 'Awaiting Review' WHEN 'being_reviewed' THEN 'Awaiting more information' WHEN 'accepted' THEN 'Current' WHEN 'rejected' THEN 'Deactivated' ELSE 'Other' END as state from users as u join user_roles ur on ur.user_id=u.id  join profiles as p on p.user_id=u.id where u.id not in (#{current_user.id}) and ur.role_id = 1 and u.confirmed_at is not null "
    else
      #@sql = "select u.first_name, u.last_name,p.profile_state, u.region, ur.role_id,(select first_name from users as us inner join user_roles u_r on u_r.user_id=us.id where u_r.role_id=2 and us.region=u.region limit 1) as manager from users u inner join user_roles ur on u.id=ur.user_id  join profiles as p on p.user_id = u.id and ur.role_id = 2 where u.region='#{current_user.region}' "
      @sql="select p.gender,u.region,TO_CHAR(p.created_at :: DATE, 'mm-dd-yyyy') as date,u.first_name || ' ' || u.last_name as name,u.id user_id,p.id as profile_id,u.first_name,u.last_name,CASE profile_state WHEN 'new' THEN 'New' WHEN 'awaiting_review' THEN 'Awaiting Review' WHEN 'being_reviewed' THEN 'Awaiting more information' WHEN 'accepted' THEN 'Current' WHEN 'rejected' THEN 'Deactivated' ELSE 'Other' END as state from users as u join user_roles ur on ur.user_id=u.id  join profiles as p on p.user_id=u.id where u.id not in (#{current_user.id}) and ur.role_id = 1 and u.confirmed_at is not null "
    end
    
   case state
    when  "new_requests"
      @query=" and (p.profile_state='new' or p.profile_state='awaiting_review')"
    when "in_review"
      @query = " and p.profile_state='being_reviewed'"
    when "current"
      @query = " and p.profile_state='accepted' "
    when "deactivated"
      @query = " and p.profile_state='rejected'"
    when "all"
    @query = "and p.profile_state!='rejected'"
  end
    @sql=@sql << @query << filter << " order by u.created_at DESC"
    
    ActiveRecord::Base.connection.execute(@sql)
  end

  #private
  # def send_confirmation_email
  #   self.send_confirmation_instructions
  # end
 end
