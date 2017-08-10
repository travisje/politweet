class CreateCommittees < ActiveRecord::Migration[5.1]
  def change
    create_table :committees do |t|
      t.string :fec_id
      t.string :type
      t.string :name
      t.string :election_cycles
      t.string :candidate_id

      t.timestamps null: false
    end
  end
end
