class SmsController < ApplicationController
  
  def phone_call
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Please go to you are connecting dot com for more information.', :voice => 'woman'
    end 
   end
  
  def index
    puts 'Incoming text message received'
    info = params
    
    # For nexma response
    # phone_number = info['msisdn']
    # message_id = info['messageId']
    # message = info['text']
    # time = DateTime.parse(info['message-timestamp'])    # 2012-08-28 04:45:58
    
    # Parse twilio response
    phone_number = info["From"]
    message = info["Body"]
    message_id = info["SmsMessageSid"]
    
    check_phone_length!(phone_number)
        
    @user = User.find_by_phone(phone_number)
    if @user
      if @user.good_to_go?
        puts 'the user does exist in our database'
        get_intent(message, phone_number, @user)
      else
        puts 'the user does exist in our database but appears to not hove completed registration.'
        message = "Hi! You have not completed registration. Need to validate your phone! If you are having problems email contact@urconnecting.com. Thanks!"
        send_message(phone_number, message)
      end
    else
      puts 'we will send them a message telling them to register first'
      message = "Greetings! You don't seem to be registered for our service. Please go to www.urconnecting.com and follow the steps!"
      send_message(phone_number, message)
    end 
    render :nothing => true
  end
  
  
  private
    def get_intent(message, phone_number, user)
      puts 'getting intent of the message'
      first = message.first
      if first == '#'
        last = message[1..-1]
        case last
        when "on" then add_to_waiting(phone_number)
        when "talk" then add_to_waiting(phone_number)
        when "find" then add_to_waiting(phone_number)
        when "play" then add_to_waiting(phone_number)
        when "begin" then add_to_waiting(phone_number)
          
        when "next" then new_partner(phone_number)
          
        when "how" then send_help(phone_number)
        when "options" then send_help(phone_number)
          
        when "off" then stop_chat(phone_number)
        when "end" then stop_chat(phone_number)
        when 'stats' then show_stats(phone_number)
        else unknown_message(phone_number)
        end
      else
         msg(phone_number, message)
      end
    end
    
    def get_user(phone_number)
      if User.find_by_phone(phone_number)
        User.find_by_phone(phone_number)
      else
        false
      end
    end
    
    def add_to_waiting(phone_number)
      if $redis.SISMEMBER("waiting", phone_number) == 1
        message = "You are already waiting for a partner. We will send you a message when one becomes available!"
        send_message(phone_number, message)
      elsif $redis.SISMEMBER("talking", phone_number) == 1
        message = "You are already talking to someone. For a new partner message #next"
        send_message(phone_number, message)
      else
        $redis.SADD("waiting", phone_number)
      end
      
      found = find_partner(phone_number)
      if !found
        message = 'Everyone else is currently talking. You will be alerted when someone comes available!'
        send_message(phone_number, message)
      end
    end
    
    def find_partner(phone_number)
      num_waiting = $redis.SCARD('waiting')
      if num_waiting < 2
        return false
      end
      $redis.SREM('waiting', phone_number)
      num1 = phone_number
      num2 = $redis.SPOP('waiting')
      
      $redis.SET(num1, num2)
      $redis.SET(num2, num1)
      
      Conversation.start_conversation(num1, num2)
      
      $redis.SADD("talking", num1)
      $redis.SADD("talking", num2)
      
      message_users_begin_chat(num1, num2)
      true
    end
    
    def message_users_begin_chat(num1, num2)
      user1 = User.find_by_phone(num1)
      user2 = User.find_by_phone(num2)
      
      message1 = user1.user_info
      message2 = user2.user_info
      
      send_message(num1, message2)
      send_message(num2, message1)
    end
    
    def new_partner(phone_number)
      if ($redis.SISMEMBER("waiting", phone_number) == 1)
        message = "You are already waiting for a partner. You will be alerted when one comes availabel!"
        send_message(phone_number, message)
      elsif ($redis.SISMEMBER("waiting", phone_number) == 0 && $redis.SISMEMBER("talking", phone_number) == 0)
        add_to_waiting(phone_number)
      elsif ($redis.SISMEMBER("talking", phone_number) == 1)
        peer = $redis.GET(phone_number)
        $redis.DEL(phone_number)
        
        Conversation.end_convo(phone_number)
        
        if peer
          $redis.SREM('talking', peer)
          $redis.SREM('talking', phone_number)
          $redis.DEL(peer)
          message = 'Your partner has disconnected. You will be matched to a new user. If you want to stop talking as well message #off'
          send_message(peer, message)
          add_to_waiting(peer)
          message = 'You have asked to find a new partner. We will find you one right away!'
          send_message(phone_number, message)
          add_to_waiting(phone_number)
        else
          $redis.SREM('talking', phone_number)
          message = 'You have asked to find a new partner. We will find you one right away!'
          send_message(phone_number, message)
          add_to_waiting(phone_number)
        end        
      end
    end
        
    def stop_chat(phone_number)
      if ($redis.SISMEMBER("waiting", phone_number) == 0 && $redis.SISMEMBER("talking", phone_number) == 0)
        message = 'You are already signed out. If you want to start talking respond with #talk'
        send_message(phone_number, message)
      elsif $redis.SISMEMBER("waiting", phone_number) == 1
        $redis.SREM('waiting', phone_number)
        message = 'You have been removed from the waiting list and wont be paired up to talk to anyone. Whenever you want to talk again send #talk to this number'
        send_message(phone_number, message)
      elsif $redis.SISMEMBER("talking", phone_number) == 1
        $redis.SREM('talking', phone_number)
        peer = $redis.GET(phone_number)
        $redis.DEL(phone_number)
        
        Conversation.end_convo(phone_number)
        
        if peer
          $redis.SREM('talking', peer)
          $redis.DEL(peer)
          message = 'Your partner has disconnected. You will be matched to a new user. If you want to stop talking as well message #off'
          send_message(peer, message)
          add_to_waiting(peer)
        end
        message = 'You have disconnected. You will not receive any messages. When you want to talk again message #talk to this number'
        send_message(phone_number, message)
      end
    end
    
    def msg(phone_number, msg)
      if ($redis.SISMEMBER("waiting", phone_number) == 0 && $redis.SISMEMBER("talking", phone_number) == 0)
        message = 'You are signed out. If you want to find someone to talk with respond with #talk'
        send_message(phone_number, message)
      elsif $redis.SISMEMBER("waiting", phone_number) == 1
        $redis.SREM('waiting', phone_number)
        message = 'You are currently on the waiting list so this message has no one to go to. When someone becomes available you will be alerted!'
        send_message(phone_number, message)
      elsif $redis.SISMEMBER("talking", phone_number) == 1
        peer = $redis.GET(phone_number)
        if !peer
          puts 'eek user must have disconnected'
          message = 'Uh oh, your user must have disconnected. We will go ahead and find you someone else.'
          send_message(phone_number, message)
          add_to_waiting(phone_number)
        end
        Message.add_message(phone_number, msg)
        message = "Partner: #{msg}"
        send_message(peer, message)
      end
    end

    def send_help(phone_number)
      puts 'we will be sending help'
      message = "#talk = Find Partner, #next = Find New Partner, #off = Sign Out, #options = This Message"
      send_message(phone_number, message)
      puts 'help sent'
    end  
    
    def pair_up(user_playing)
      puts 'gonna pair up some people'
      if UserPlaying.waiting_users?
        puts 'There are currently no users waiting to talk. When one comes available you will be paired up'
      end
    end
    
    def show_stats(phone_number)
      num_waiting = $redis.SCARD('waiting')
      num_talking = $redis.SCARD('talking')
      total_users = User.count
      message = "Waiting: #{num_waiting}, Talking: #{num_talking}, Registered Users: #{total_users}"
      send_message(phone_number, message)
    end
    
    # Sends a message to specified message
    def send_message(number, message)
      puts "sending message to #{number}"
    #   puts 'the message is'
    #   puts message
    #   if message.length > 155
    #     puts 'this message must be broken down into small pieces. Fucking twilio'
    #     chunks = message.scan(/.{150}/)
    #     puts chunks
    #     num = chunks.count
    #     puts "the number is: #{num}"
    #     count = 1
    #     chunks.each do |chunk|
    #       puts 'sending a chunk'
    #       mess = chunk.insert(0, "(#{count}/#{num}) ")
    #       count += 1
    #       $sms.account.sms.messages.create(
    #         :from => '+14509000103',
    #         :to => number,
    #         :body => mess
    #       )
    #     end
    #   else
    #         
    #   puts "Sending a message to #{number}"
    #   $sms.account.sms.messages.create(
    #     :from => '+14509000103',
    #     :to => number,
    #     :body => message
    #   )
    # end
      response = $sms.send_message({
        from: '16477252253',
          to: number,
        text: message
      })
      
      if response.success?
        puts "Sent message #{response.message_id}"
      elsif response.failure?
        raise response.error
      end
    end
    
    def unknown_message(phone_number)
      message = 'Sorry. I am not sure what that command is. Here are the commands.'
      send_message(phone_number, message)
      send_help(phone_number)
    end
    
    def check_phone_length!(phone)
      if phone.length == 10
        phone.insert(0, '1')
      end
      if phone.length == 12
        phone[0] = ''
      end
      phone
    end
end
