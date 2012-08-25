class RemoveBeginnerIdFromConversations < ActiveRecord::Migration
  def up
    remove_column :conversations, :beginner_id
  end

  def down
    add_column :conversations, :beginner_id, :integer
  end
end
