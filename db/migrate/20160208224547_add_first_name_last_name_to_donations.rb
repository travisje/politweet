class AddFirstNameLastNameToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :first_name, :string
    add_column :donations, :last_name, :string
  end
end
