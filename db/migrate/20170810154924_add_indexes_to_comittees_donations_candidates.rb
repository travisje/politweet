class AddIndexesToComitteesDonationsCandidates < ActiveRecord::Migration[5.1]
  def change
    add_index :committees, :fec_id
    add_index :candidates, :fec_id
    add_index :donations, :rptcom_fec_id
  end
end
