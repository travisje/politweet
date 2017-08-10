class RemoveMemoTxtFromDonations < ActiveRecord::Migration[5.1]
  def change
    remove_column :donations, :memo_txt, :string
  end
end
