class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.string :filename

      t.timestamps null: false
    end
  end
end
