class CreateDonations < ActiveRecord::Migration[5.1]
  def change
    create_table :donations do |t|
      t.datetime :date
      t.string :fec_record_num
      t.string :donor_name
      t.string :donor_co
      t.string :donor_occupation
      t.string :donor_state
      t.decimal :amount
      t.string :fec_id
      t.integer :candidate_id

      t.timestamps null: false
    end
  end
end
