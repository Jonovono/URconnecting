class Conversation < ActiveRecord::Base
  attr_accessible :beginner_id, :ended_at, :status, :user1_id, :user2_id
  
  belongs_to :user1, :class_name => "User"
  has_many :messages
end
