class Conversation < ActiveRecord::Base
  attr_accessible :status, :user1_id, :user2_id
  
  # before_save :only_one_active_conversation
  # before_save :only_one_waiting_conversation
  
  ENDED = 0
  ACTIVE = 1
  
  # belongs_to :user1, :class_name => "User"
  # belongs_to :user1, :class_name => "User"
  has_many :user_playing
  has_many :messages
  has_many :users, :through => :user_playing
  
  
  def status?
    st = self.status
    if st == ENDED
      "ended"
    elsif st == ACTIVE
      "active"
    end
  end
  
  def self.end_convo(phone_number)
    user = User.find_by_phone(phone_number)
    current = user.current_convo?
    ended = DateTime.now
    current.ended_at = ended
    current.status = 0
    current.save
  end
    
    
  
  def self.start_conversation(num1, num2)
    c = Conversation.create!(:status => 1)
    us1 = User.find_by_phone(num1)
    us2 = User.find_by_phone(num2)
    
    up1 = UserPlaying.create!(:user_id => us1.id, :conversation_id => c.id, :status => 2)
    up2 = UserPlaying.create!(:user_id => us2.id, :conversation_id => c.id, :status => 2)
  end
  
  # def active?
  #   users = self.user_playing
  #   in_session = true
  #   users.each do |us|
  #     if us.status == 0
  #       in_session = false
  #     end
  #   end
  #   in_session
  # end
  
  # Validations
  # def only_one_active_conversation
  #   puts 'are you not validatiing'
  #   Conversation.where(:user1_id => 5, :status => 2).count < 1
  # end
  # 
  # def only_one_waiting_conversation
  #   Conversation.where(:user1_id => 5, :status => 1).count < 1
  # end
  
end
