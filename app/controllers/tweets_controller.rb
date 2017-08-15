class TweetsController < ApplicationController
  
  def new
    
  end

  def create
    #TODO add error messages, non logged in user, no existent tweet, etc
    if current_user

      donation = Donation.find(params[:tweet][:donation_id])
      tweet = Tweet.new(user: current_user, donation: donation)
      if tweet.tweet(current_user, params[:tweet][:text])
        puts 'correct params'
        tweet.save
      end
      redirect_to root_path

      #TODO account for user without token

    else
      "sorry must be logged in"
    end
  end

end