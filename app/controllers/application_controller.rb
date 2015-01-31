class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :auth_hash
  helper_method :authed_user
  # before_filter :enforce_auth ## Use this in your own controllers hidden behind auths.
  # before_filter :enforce_superuser ## Use this in your own controllers hidden behind auths.
  
  protected
  
  def enforce_auth
    auth_hash
    
    if auth_hash.blank?
      session[:after_auth_url] = request.url
      session[:current_user] = nil
      redirect_to '/auth/github'
      return false
    end
    return true
  end
  
  def enforce_superuser    
    if !enforce_auth
      return false
    end
    
    if !authed_user || !authed_user.superuser 
      session[:after_auth_url] = request.url
      session[:current_user] = nil
      redirect_to '/auth/linkedin'
      return false
    end
    return true
  end
  
  def auth_hash
    return session[:current_user] ? session[:current_user] : (session[:current_user] = request.env['omniauth.auth'])
  end
  
  def authed_user
    @authed_user ||= begin
      if auth_hash.blank?
        nil
      else
        existing_user = User.find_by_githubid(auth_hash['uid'])
        unless existing_user
          existing_user = User.create_or_update_user_from_omniauth(auth_hash)
        end
        existing_user
      end
    end
  end
end
