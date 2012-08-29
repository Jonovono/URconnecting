class CreateUserPlayings < ActiveRecord::Migration
  def change
    create_table :user_playings do |t|
      t.integer :user_id
      t.integer :status
      t.datetime :date_joined
      t.datetime :time_waiting
      t.integer :conversation_id

      t.timestamps
    end
  end
end
