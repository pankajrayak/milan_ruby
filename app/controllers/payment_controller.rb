class PaymentController < ApplicationController


#create new card and save
def create_card
    if billing_address_params.present?
    billing_address=BillingAddress.new(billing_address_params)
    billing_address.user_id=current_user.id
    billing_address.save
    #create card and make payment
    Charge.create_card(current_user,payment_params[:nonce])
    render json: "successfully paid"
    else
    render json: "not paid"
    end
end





private
def payment_params
    params.require(:payment).permit(:nonce)
  end
  def billing_address_params
    params.require(:billing_address).permit(:first_name,:last_name,:email,:zipcode,:address_line_one,
      :address_two_one,
      :city,:phone)
  end

end
