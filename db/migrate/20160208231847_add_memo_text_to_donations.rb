class AddMemoTextToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :memo_text, :string
  end
end
