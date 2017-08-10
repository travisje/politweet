class AddCommitteeIdToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :committee_id, :integer
  end
end
