class AddTwitterHandleAndNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :twitter_handle, :string
    add_column :users, :name, :string
  end
end
