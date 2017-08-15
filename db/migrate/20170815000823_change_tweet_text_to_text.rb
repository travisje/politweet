class ChangeTweetTextToText < ActiveRecord::Migration[5.1]
  def change
    rename_column :tweets, :tweet_text, :text
  end
end
