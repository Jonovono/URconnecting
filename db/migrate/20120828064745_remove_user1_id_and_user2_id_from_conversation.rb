class RemoveUser1IdAndUser2IdFromConversation < ActiveRecord::Migration
  def up
    remove_column :conversations, :user1_id
    remove_column :conversations, :user2_id
  end

  def down
    add_column :conversations, :user2_id, :integer
    add_column :conversations, :user1_id, :integer
  end
end
