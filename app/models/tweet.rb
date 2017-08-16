class Tweet < ActiveRecord::Base
  belongs_to :donation
  belongs_to :user

  def client(user)
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['tw_consumer_key']
      config.consumer_secret = ENV['tw_consumer_secret']
      config.access_token = user.twitter_token
      config.access_token_secret = user.twitter_secret
    end
  end


  def tweet_out(user)
    response = client(user).update(text)
    self.tweet_id = response.id.to_s
  end


end
