class AddDonorNameDonorCoDonorOccupationDonorStateToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :full_name, :string
    add_column :donations, :employer, :string
    add_column :donations, :occupation, :string
    add_column :donations, :state, :string
  end
end
