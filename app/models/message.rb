class Message < ActiveRecord::Base
  attr_accessible :conversation_id, :message, :sent, :user_id
  
  belongs_to :conversation
end
