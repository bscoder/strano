class ApplicationController < ActionController::Base
  protect_from_forgery
    
  private
  
    def authenticate_user!
      unless user_signed_in?
        redirect_to sign_in_url, :alert => 'You need to sign in for access to this page.'
      end
    end
end
