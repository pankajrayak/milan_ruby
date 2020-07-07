class Charge < ApplicationRecord
  has_paper_trail
  belongs_to :user
  #Workflow state
  include Workflow
  workflow_column :state
  workflow do
    state :pending do
      event :paid, :transitions_to => :success
      event :unpaid, :transitions_to => :failed
    end
   state:success
   state:failed
  end
    
  PRICE=00   #1100


def self.get_location
  locations_api = SquareConnect::LocationsApi.new
  begin
  locations_response = locations_api.list_locations
  puts locations_response
  rescue SquareConnect::ApiError => e
    #raise "Error encountered while listing locations: #{e.message}"
    return [nil, { :error => "Error encountered while listing locations. Message: #{e.message}" }]
  end
  # Get a location able to process transaction
  location = locations_response.locations.find do |l|
   l.capabilities.include?("CREDIT_CARD_PROCESSING")
  end

  if location.nil?
    #raise "Activation required. Visit https://squareup.com/activateto activate and begin taking payments."
    return [nil, { :error => "Activation required. Visit https://squareup.com/activateto activate and begin taking payments." }]
    
  end
  return [location,{ :success => "true" }] 
  
end

def self.create_card(user,card_nonce)
  
  @data, @message = get_location() 
  
  if @message[:error].present?
    return [nil, @message ]
  else 
    location = @data 
    customer_api = SquareConnect::CustomersApi.new
    reference_id = SecureRandom.uuid

    customer_request = {
      given_name: user.first_name,
      email_address: user.email,
      reference_id: reference_id,
      note: 'a customer'
    }
    begin
      customer_response = customer_api.create_customer(customer_request)
      puts customer_response.customer.id #customer ID
      rescue SquareConnect::ApiError => e
      #raise "Error encountered while creating customer: #{e.message}"
      return [nil, { :error => "Error encountered while creating customer. Message: #{e.message}" }]
    end

    customer = customer_response.customer
    customer_card_request = {
      card_nonce: card_nonce,
      # billing_address: {
      #   # "address_line_1": "500 Electric Ave",
      #   # "address_line_2": "Suite 600",
      #   # "locality": "New York",
      #   # "administrative_district_level_1": "NY",
      #   "postal_code": "94103"    # using 94103 for sandbox otherwise request
      #   #"country": "US"
      # },
      cardholder_name: "#{user.first_name} #{user.last_name}"
      }
    begin
      customer_card_response = customer_api.create_customer_card(customer.id, customer_card_request)
      puts 'CustomerCard ID to use with Charge:'
      puts customer_card_response.card.id
    rescue SquareConnect::ApiError => e
    # raise "Error encountered while creating customer card: #{e.message}"
      return [nil, { :error => "Error encountered while creating customer card. Message: #{e}" }]
    end

    customer_card = customer_card_response.card
    transactions_api = SquareConnect::TransactionsApi.new
    idempotency_key = SecureRandom.uuid
    amount_money = { :amount => PRICE, :currency => 'USD' }

    transaction_request = {
      :customer_id => customer.id,
      :customer_card_id => customer_card.id,
      :amount_money => amount_money,
      :idempotency_key => idempotency_key
    }

    begin
      transaction_response = transactions_api.charge(location.id, transaction_request)
    rescue SquareConnect::ApiError => e
      #raise "Error encountered while charging card: #{e.message}"
      return [nil, { :error => "Error encountered while charging card. Message: #{e.message}" }]
    end

    if(transaction_response.transaction.tenders[0].card_details.status=='AUTHORIZED')
      charge_records(user.id,transaction_response.transaction.id,PRICE,false)
      return [nil,{ :success => "true" }] 
    else
      @charge_record=Charge.new(amount: PRICE ,charge_id:transaction_response.transaction.id,user_id:user.id)
      if @charge_record.save
        @charge_record.paid!
        User.extend_date(user,1)
        return [nil,{ :success => "true" }] 
      # charge_records(resp.transaction.id,user_id,amount,true)
      end
    end

  end

  
end

# payment using squareConnect
  def self.make_payment(nonce_id,user_id,amount_pay)
    transactions_api = SquareConnect::TransactionsApi.new
    request_body = {
      :card_nonce => nonce_id,
      :amount_money => {
        :amount => amount_pay,
        :currency => 'USD'
      },
      :idempotency_key => SecureRandom.uuid
    }
  location_id = get_location()
    begin
      resp = transactions_api.charge(location_id, request_body)
    rescue SquareConnect::ApiError => e
      Rails.logger.error("Error encountered while charging card:: #{e.message}")
     # render json: {:status => 400, :errors => JSON.parse(e.response_body)["errors"]}
     return
    end
    if(resp.transaction.tenders[0].card_details.status=='AUTHORIZED')
      charge_records(resp.transaction.id,user_id,amount,false)
   else
    @charge_record=Charge.new(amount: amount_pay ,charge_id:resp.transaction.id,user_id:user_id)
    if @charge_record.save
      @charge_record.paid!
      User.extend_date(user,1)
     # charge_records(resp.transaction.id,user_id,amount,true)
     end
     end
  end


  private 
  def charge_records(user_id,transaction_id,amount,paid)
    
    @charge_record=Charge.new(amount: @cost ,charge_id:transaction_id,user_id:user_id)
    if @charge_record.save
      if paid
        @charge_record.paid!
      @user=User.find_by_id(user_id)
      User.extend_date(@user,1)
      # User.expiry_date(user_id)
      else
        @charge_record.unpaid!
      end
   end
  end

end
