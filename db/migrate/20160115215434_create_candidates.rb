class CreateCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates do |t|
      t.string :first_name
      t.string :last_name
      t.string :party
      t.string :chamber
      t.string :district
      t.string :state
      t.string :category
      t.string :twitter_handle
      t.string :fec_id
      t.timestamps null: false
    end
  end
end
