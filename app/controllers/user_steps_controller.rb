class UserStepsController < ApplicationController
   include Wicked::Wizard
   
   steps :phone
   
   def show
     puts 'wickedddd'
     @user = current_user
     puts @user
     render_wizard
   end
   
   def update
     puts 'updating the user'
     puts params
     @user = current_user
     params[:user][:status] = 'active' if step == steps.last
     @user.attributes = params[:user]
     render_wizard @user
   end
   
   private

   def finish_wizard_path
     home_how_path
   end
end
