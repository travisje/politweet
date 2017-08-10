class AddOtherIdToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :other_id, :string
  end
end
