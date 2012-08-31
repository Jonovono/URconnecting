class Message < ActiveRecord::Base
  attr_accessible :conversation_id, :message, :sent, :user_id
  
  belongs_to :conversation
  
  def self.add_message(phone_number, message)
    user = User.find_by_phone(phone_number)
    convo = user.current_convo?
    convo.messages.create(:user_id => user.id, :message => message)
  end
end
