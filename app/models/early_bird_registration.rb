class EarlyBirdRegistration < ApplicationRecord

    def self.is_paid(email)
        EarlyBirdRegistration.find_by_email(email.strip).present? || true 
    end
end
