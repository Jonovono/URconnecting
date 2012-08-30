class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end
  
  def confirmation
    puts 'atttconfirm'
    puts params
    puts current_user
    @email = params[:email]
  end
  
  def how
    puts 'hohohhohowowow'
    puts params
    puts current_user
  end
  
  def phone_update
    @user = current_user
    puts 'updatingtheuser'
    puts params
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to home_how_path, notice: 'Added information!!.' }
        format.json { head :no_content }
      else
        format.html { render action: "phone" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def phone
    @user = current_user
  end
  
  def send_confirmation
    puts 'sending confirmation'
    puts params
    @phone = params[:phone]
    @user = current_user
    puts current_user
        
    message = "Hello. Thanks for registering on **. Your confirmation code is #{@user.phone_confirm}. Please enter it on that same page and click submit!"
    
    # response = $sms.send_message({
    #   from: '16477252253',
    #     to: @phone,
    #   text: message
    # })
    
    $sms.account.sms.messages.create(
      :from => '+14509000103',
      :to => @number,
      :body => message
    )
    render :nothing => true
  end
end
