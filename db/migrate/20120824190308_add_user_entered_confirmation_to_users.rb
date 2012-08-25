class AddUserEnteredConfirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_entered_confirmation, :string
  end
end
