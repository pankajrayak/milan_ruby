
class SessionsController < DeviseTokenAuth::SessionsController

def render_create_error_not_confirmed
    if @resource.state=="deactivated"
    render_error(401, I18n.t('devise.failure.account_inactive'))
    else
    render_error(401, I18n.t('devise_token_auth.sessions.not_confirmed', email: @resource.email))
    end
end
end