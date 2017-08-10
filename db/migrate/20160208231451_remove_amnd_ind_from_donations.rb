class RemoveAmndIndFromDonations < ActiveRecord::Migration[5.1]
  def change
    remove_column :donations, :amnd_ind, :string
  end
end
