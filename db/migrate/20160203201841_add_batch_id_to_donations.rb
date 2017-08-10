class AddBatchIdToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :batch_id, :integer
  end
end
