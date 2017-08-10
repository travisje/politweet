class RemoveTypeFromCommittees < ActiveRecord::Migration[5.1]
  def change
    remove_column :committees, :type, :string
  end
end
