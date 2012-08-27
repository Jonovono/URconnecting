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
  
  def phone
    @user = current_user
  end
  
  def send_confirmation
    puts 'sending confirmation'
    puts params
    @phone = params[:phone]
    @user = current_user
    puts current_user
    sms = Urdating::Application::SMS
    
    message = "Hello. Thanks for registering on **. Your confirmation code is #{@user.phone_confirm}. Please enter it on that same page and click submit!"
    
    response = sms.send_message({
      from: '16477252253',
        to: @phone,
      text: message
    })
    render :nothing => true
  end
end
