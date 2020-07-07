class Interest < ApplicationRecord
  has_paper_trail
  belongs_to :user
  has_many :notifications
  after_create_commit { create_event }
  after_update_commit { update_event }
  include CustomMethods
 # after_update_commit { update_event }
  include Workflow
  workflow_column :state
  workflow do
    state :awaiting_response do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
      event :cancel, :transitions_to => :canceled
    end
    state :accepted do
     event :close_connection, :transitions_to => :not_interested
     event :report_connection, :transition_to => :report
    end
    state :report do 
      event :new, :transitions_to => :awaiting_response
    end
    state :rejected do
      event :new, :transitions_to => :awaiting_response
    end
    state :not_interested do
      event :new, :transitions_to => :awaiting_response
    end
    state :calceled do
      event :new, :transitions_to => :awaiting_response
    end
  end


#filter
scope :remove_expired, ->{where.not user_to: User.expired_user_ids} 


 def create_event
    Notification.create(user_id:self.user_id,recipient_id: self.user_to,action:'invite',message: 'hey i am inviting you')
 end


 def self.received(id)
  Interest.where(user_to:id) 

 end

 def self.sent(id)
  Interest.where(user_id:id)
 end

 def self.get_dob(age,value )
  CustomMethods.standard_date(age,value)
 end


 def update_event
  begin
    # Output a title value which is undeclared.
    @sender="#{current_user.first_name  current_user.last_name}"
    @body=  "#{@sender} has #{action} your request on milan"
   
    # finding recipient
    @recipient_id= (self.user_id === current_user.id)? self.user_to : self.user_id
     if self.state=='not_interested'  #no longer connected
      @body=  "#{@sender} is no longer connected with you on milan"
      end
  Notification.create(user_id:current_user.id,recipient_id: @recipient_id,action:self.state,message:  @body )
rescue NameError => e 
rescue => e
   
end
  
  
  end

end