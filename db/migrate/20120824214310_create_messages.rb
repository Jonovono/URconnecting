class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :conversation_id
      t.text :message
      t.integer :user_id
      t.datetime :sent

      t.timestamps
    end
  end
end
