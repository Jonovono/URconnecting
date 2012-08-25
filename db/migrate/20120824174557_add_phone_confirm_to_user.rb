class AddPhoneConfirmToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_confirm, :string
  end
end
