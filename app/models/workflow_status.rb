class WorkflowStatus < ApplicationRecord
  has_paper_trail
  belongs_to :user

  def self.regional_admin_workflow(comment,action_type,state,user_id)
   @workflowstatus=  WorkflowStatus.new
   @workflowstatus.comment=comment
   @workflowstatus.module=action_type
   @workflowstatus.state=state
   @workflowstatus.user_id= user_id
   @workflowstatus.save
  end

end
