class UserPlaying < ActiveRecord::Base
  attr_accessible :conversation_id, :date_joined, :status, :time_waiting, :user_id
  
  before_save :only_one_active_conversation
  before_save :only_one_waiting_conversation
  
  ENDED = 0
  WAITING = 1
  TALKING = 2
  
  belongs_to :user
  belongs_to :conversation
  
  
  # Validations
  def only_one_active_conversation
    puts 'are you not validatiing'
    UserPlaying.where(:user_id => self.user.id, :status => 2).count < 1 if self.status == 1 || self.status == 2
  end
  
  def only_one_waiting_conversation
    UserPlaying.where(:user_id => self.user.id, :status => 1).count < 1 if self.status == 1 || self.status == 2
  end
  
  def self.waiting_users
    UserPlaying.where(:status => 1)
  end
  
  def self.longest_waiting_user
    UserPlaying.where(:status => 1)
  end
  
  def self.waiting_users?
    up = UserPlaying.where(:status => 1)
    if !up.empty?
      true
    else
      false
    end
  end
    
  
end
