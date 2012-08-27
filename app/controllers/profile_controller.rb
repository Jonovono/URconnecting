class ProfileController < ApplicationController
  def index
    @user = current_user
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

  def edit
  end
end
