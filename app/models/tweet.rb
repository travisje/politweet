class Tweet < ActiveRecord::Base
  belongs_to :donation

  def initialize
    @@client ||= Tweet.new_client
  end

  def self.new_client
    @@client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['tw_consumer_key']
      config.consumer_secret = ENV['tw_consumer_secret']
      config.access_token = ENV['tw_access_token']
      config.access_token_secret = ENV['tw_access_token_secret']
    end
  end

  def tweet(text)
    client.update(text)
  end

  def client
    @@client
  end


end
