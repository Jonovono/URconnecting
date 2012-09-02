class UserStepsController < ApplicationController
   include Wicked::Wizard
   
   # steps :phone, :info
   steps :phone
   
   def show
     puts 'wickedddd'
     puts User.count
     puts params
     puts params[:user_id]
     @user = current_user
     puts @user
     render_wizard
   end
   
   def update
     puts 'updating the user'
     puts params
     @user = current_user
     puts @user
     params[:user][:status] = step.to_s
     params[:user][:status] = 'active' if step == steps.last
     puts params[:user]
     @user.attributes = params[:user]
     puts 'kkkkwtf'
     puts @user
     render_wizard @user
   end
   
   private

   def finish_wizard_path
     home_how_path
   end
end
