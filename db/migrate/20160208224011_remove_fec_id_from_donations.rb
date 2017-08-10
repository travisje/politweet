class RemoveFecIdFromDonations < ActiveRecord::Migration[5.1]
  def change
    remove_column :donations, :fec_id, :string
  end
end
