class ProfileController < ApplicationController
  def index
    @user = current_user
  end
  
  def updating
    puts 'updating for old user'
    email = params[:email]
    puts email
    @user = User.find_by_email(email)
  end
  
  def update
    @user = current_user
    puts 'updatingtheuser'
    puts params
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to home_how_path, notice: 'Added information!!.' }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def old_update
      @user = User.find_by_email(params[:user]["email"])
      puts 'updatingtheuser'
      puts params

      respond_to do |format|
        if @user.update_attributes(params[:user])
          sign_in @user
          format.html { redirect_to home_how_path, notice: 'Added information!!.' }
          format.json { head :no_content }
        else
          format.html { render action: "updating" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  

  def edit
  end
end
