class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :tweet_text
      t.string :tweet_url
      t.integer :donation_id

      t.timestamps null: false
    end
  end
end
