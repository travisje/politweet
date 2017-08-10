class AddAmndtIndToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :amndt_ind, :string
  end
end
