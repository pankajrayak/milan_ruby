class Jobstatus < ApplicationRecord
    belongs_to :profile,required: false
end
