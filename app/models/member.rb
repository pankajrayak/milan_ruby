class Member < ApplicationRecord
    belongs_to :user
    #Summary: On first request it will return true and for other scenario when data export is false and it's been 3 days then export button will be visible
    def show_export 
        (!self.export_request_on)|| (self.export_request_on.to_date + 3.days < Date.today )
    end
end