class ApplicationController < ActionController::API
  delegate :t, to: I18n
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
   before_action :set_locale
  respond_to :json
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :region, :confirmed_at]) #<< :favorite_color
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name]) #<< :favorite_color
   # devise_parameter_sanitizer.for(:account_update, keys: [:first_name, :last_name]) << :nickname
  end

  def user_for_paper_trail
    # Save the user responsible for the action
    user_signed_in? ? current_user.id : 'Guest'
  end

  def authenticate_admin
    role=UserRole.get_roles(current_user)
    unless user_signed_in? && ((role.include?'RGN') ||  (role.include?'GBL'))
        #rescue "No-access" 
    end
  end
  
end
