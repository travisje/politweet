class AddCategoryToCommittees < ActiveRecord::Migration[5.1]
  def change
    add_column :committees, :category, :string
  end
end
