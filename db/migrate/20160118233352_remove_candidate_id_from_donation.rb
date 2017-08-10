class RemoveCandidateIdFromDonation < ActiveRecord::Migration[5.1]
  def change
    remove_column :donations, :candidate_id, :integer
  end
end
