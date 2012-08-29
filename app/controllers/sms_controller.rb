class SmsController < ApplicationController
  def index
    puts 'Incoming text message received'
    info = params
    
    phone_number = info['msisdn']
    check_phone_length!(phone_number)
    
    message_id = info['messageId']
    message = info['text']
    time = DateTime.parse(info['message-timestamp'])    # 2012-08-28 04:45:58
        
    @user = find_user(phone_number)
    if @user
      puts 'the user does exist in our database'
      get_intent(message, phone_number, @user)
    else
      puts 'we will send them a message telling them to register first'
      message = "Greetings! You don't seem to be registered for our service. Please go to www.urconnecting.com and follow the steps!"
      send_message(phone_number, message)
    end 
  end
  
  
  private
    def get_intent(message, phone_number, user)
      puts 'getting intent of the message'
      first = message.first
      if first == '#'
        last = message[1..-1]
        intent = case last
        when "start" then find_partner(user)
        when "next" then new_partner
        when "help" then send_help(phone_number)
        when "options" then send_help(phone_number)
        when "stop" then stop_chat
        when "end" then stop_chat
        end
      end
    end
    
    def get_user(phone_number)
      if User.find_by_phone(phone_number)
        User.find_by_phone(phone_number)
      else
        false
      end
    end
    
    def find_partner(user)
      sms = Urdating::Application::SMS
      
      if user.waiting?
        message = "You are already waiting for a partner. We will send you a message when one becomes available!"
        send_message(user.phone, message)
      elsif user.talking?
        message = "You are already in a conversation. If you want a new partner type #next"
        send_message(user.phone, message)
      else
        user_playing = UserPlaying.new(:user_id => user.id, :status => 1)
        
        if user_playing.save
          pair_up(user_playing)
        else
          puts 'failed to save the user_playing'
        end
      end
    end
    
    def send_help(phone_number)
      message = "#start = Find Partner, #next = Find New Partner, #end = Sign Out, #help = This Message"
      send_message(phone_number, message)
    end  
    
    def pair_up(user_playing)
      puts 'gonna pair up some people'
      if UserPlaying.waiting_users?
        puts 'There are currently no users waiting to talk. When one comes available you will be paired up'
      end
    end
    
    # Sends a message to specified message
    def send_message(number, message)
      response = $sms.send_message({
        from: '16477252253',
          to: phone_number,
        text: message
      })
      
      if response.success?
        puts "Sent message #{response.message_id}"
      elsif response.failure?
        raise response.error
      end
    end
    
    def check_phone_length!(phone)
      if phone.length == 10
        phone.insert(0, '1')
      end
      phone
    end
end
