class TweetsController < ApplicationController
  
  def new
    
  end

  def create
    #TODO add error messages, non logged in user, no token user, no existent tweet, etc
    if current_user

      donation = Donation.find(params[:tweet][:donation_id])
      tweet = Tweet.new(user: current_user, donation: donation, text: params[:tweet][:text])
      if tweet.tweet_out(current_user)
        puts 'correct params'
        tweet.save
      end

      render json: {success: "yeah you fuckin ajaxed that tweet"}.to_json



    else
      "sorry must be logged in"
    end
  end

end