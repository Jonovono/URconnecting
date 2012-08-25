class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :beginner_id
      t.integer :user1_id
      t.integer :user2_id
      t.datetime :ended_at
      t.integer :status

      t.timestamps
    end
  end
end
