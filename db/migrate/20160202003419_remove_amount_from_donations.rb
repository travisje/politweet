class RemoveAmountFromDonations < ActiveRecord::Migration[5.1]
  def change
    remove_column :donations, :amount, :decimal
  end
end
