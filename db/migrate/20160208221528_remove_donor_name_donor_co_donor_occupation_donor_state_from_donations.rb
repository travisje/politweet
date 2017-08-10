class RemoveDonorNameDonorCoDonorOccupationDonorStateFromDonations < ActiveRecord::Migration[5.1]
  def change
    remove_column :donations, :donor_name, :string
    remove_column :donations, :donor_co, :string
    remove_column :donations, :donor_occupation, :string
    remove_column :donations, :donor_state, :string
  end
end
