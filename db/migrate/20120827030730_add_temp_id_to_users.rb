class AddTempIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :temp_id, :integer
  end
end
