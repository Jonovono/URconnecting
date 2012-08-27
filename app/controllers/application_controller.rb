class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user_session
  
  def after_sign_up_path_for(resource)
     puts 'willitwork'
     "http://www.google.com" # <- Path you want to redirect the user to.
   end
   
   private

   def current_user_session
     puts 'findingthecurrentuser'
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end
end
