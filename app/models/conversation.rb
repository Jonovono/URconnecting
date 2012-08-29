class Conversation < ActiveRecord::Base
  attr_accessible :status, :user1_id, :user2_id
  
  # before_save :only_one_active_conversation
  # before_save :only_one_waiting_conversation
  
  # ENDED = 0
  # ACTIVE = 1
  
  # belongs_to :user1, :class_name => "User"
  # belongs_to :user1, :class_name => "User"
  has_many :user_playing
  has_many :messages
  has_many :users, :through => :user_playing
  
  
  # def status?
  #   st = self.status
  #   if st == ENDED
  #     "ended"
  #   elsif st == ACTIVE
  #     "active"
  #   end
  # end
  
  def active?
    users = self.user_playing
    in_session = true
    users.each do |us|
      if us.status == 0
        in_session = false
      end
    end
    in_session
  end
  
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
