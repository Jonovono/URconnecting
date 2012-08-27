class RemoveIndexAndCreateAndDestroyFromAuthentications < ActiveRecord::Migration
  def up
    remove_column :authentications, :index
    remove_column :authentications, :create
    remove_column :authentications, :destroy
  end

  def down
    add_column :authentications, :destroy, :string
    add_column :authentications, :create, :string
    add_column :authentications, :index, :string
  end
end
