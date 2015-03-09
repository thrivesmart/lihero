class SessionsController < ApplicationController
  def create
    logger.debug "OMNIAUTH: #{request.env['omniauth.auth'].to_json}"
    session[:current_user] = request.env['omniauth.auth']
    
    logger.debug "-----omni-----------\n#{request.env['omniauth.auth'].to_yaml}\n--------------"
    
    User.create_or_update_user_from_omniauth(request.env['omniauth.auth'])
    redirect_to session[:after_auth_url] || home_url
  end
  
  def new_linkedin_auth
    session[:after_auth_url] = params[:next]
    session[:current_user] = nil
    redirect_to '/auth/linkedin'
  end
end
