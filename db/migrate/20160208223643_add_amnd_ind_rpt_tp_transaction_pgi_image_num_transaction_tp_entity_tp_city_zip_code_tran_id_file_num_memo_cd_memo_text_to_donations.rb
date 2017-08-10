class AddAmndIndRptTpTransactionPgiImageNumTransactionTpEntityTpCityZipCodeTranIdFileNumMemoCdMemoTextToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :amnd_ind, :string
    add_column :donations, :rpt_tp, :string
    add_column :donations, :transaction_pgi, :string
    add_column :donations, :image_num, :string
    add_column :donations, :transaction_tp, :string
    add_column :donations, :entity_tp, :string
    add_column :donations, :city, :string
    add_column :donations, :zip_code, :string
    add_column :donations, :tran_id, :string
    add_column :donations, :file_num, :string
    add_column :donations, :memo_cd, :string
    add_column :donations, :memo_txt, :string
  end
end
