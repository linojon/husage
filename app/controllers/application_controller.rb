# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :set_user_time_zone
  
  helper_method :current_site, :is_admin?, :is_9series?
  
  # authlogic
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  private
    def set_user_time_zone
      Time.zone = current_user.time_zone if current_user
    end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
  
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to usages_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def current_site
      if is_admin? && params[:site]
        params[:site] 
      elsif current_user
        current_user.site
      end
    end
    
    # note: to bootstrap a new app need to create user with site id "admin"
    
    def is_admin?
      current_user && current_user.site=='admin'
    end
    
    def require_admin
      unless is_admin?
        flash[:notice] = "Access denied"
        redirect_to usages_url
        return false
      end
    end
    
    def is_9series?
      current_site && (current_site.upcase.starts_with? 'DSS')
    end
end
