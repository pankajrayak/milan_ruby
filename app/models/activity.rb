class Activity < ApplicationRecord
    belongs_to :user
after_commit -> { ActivityJob.perform_later(self) }


  
end
