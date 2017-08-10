class AddRptcomFecIdToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :rptcom_fec_id, :string
  end
end
