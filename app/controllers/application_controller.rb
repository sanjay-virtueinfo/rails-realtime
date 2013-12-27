class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :is_admin?, :is_user?
	SUPER_ADMIN = "SuperAdmin"
	USER = "user"
	layout :set_layout

  private

    def set_layout
      request.xhr? ? false : 'application'
    end  

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
	    @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        redirect_to :controller => "user_sessions", :action => "new"
      end
    end

    def authenticate_email(email)
      user = User.where(:email => email).first
      if user
			  return user
	    end
	    return false
    end

    def authenticate_change_password(password)
        user_exists = User.exists?(password: password)
        if user_exists
          user = User.where(password: password).first
		      return user
	      end
	    return false
    end

	  def is_admin?
		  session[:user_role] == SUPER_ADMIN
	  end

    def is_user?
	   session[:user_role] == USER
    end
end
