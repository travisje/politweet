class AddCrpIdToCandidate < ActiveRecord::Migration[5.1]
  def change
    add_column :candidates, :crp_id, :string
  end
end
