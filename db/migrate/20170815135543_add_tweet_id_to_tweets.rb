class AddTweetIdToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :tweet_id, :string
  end
end
