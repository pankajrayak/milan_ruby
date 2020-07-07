class Request < ApplicationRecord
  has_paper_trail
  belongs_to :user
 include Workflow
   workflow_column :status
   workflow do
    state :pending do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end


  def self.create_request(request_info,user)
    user=User.find_by id: request_info[:id]
    @request=  user.requests.new({initiated_by:request_info[:id],comment:request_info[:comment],module:'Photo'})
    if @request.save!
     "Photo request sent"
    else
      'Unable to request for photos'
    end

  end


end
