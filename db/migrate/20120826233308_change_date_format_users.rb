class ChangeDateFormatUsers < ActiveRecord::Migration
  def up
    change_column :users, :birthdate, :datetime
  end

  def down
    change_column :users, :birthdate, :string
  end
end
