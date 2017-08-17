class TweetsController < ApplicationController
  
  def new
    
  end

  def create

    #TODO add error messages, scope ajax, non logged in user, no token user, no existent tweet, etc
    if current_user

      donation = Donation.find(params[:tweet][:donation_id])
      tweet = Tweet.new(user: current_user, donation: donation, text: params[:tweet][:text])
      if tweet.tweet_out(current_user) && tweet.save
        
        render json: {status: "success"}.to_json
        return
      else
        render json: {status: "Error tweeting, please check your feed."}.to_json
      end
     
    else
      render json: {status: "error", message: "Sorry, you must be logged in to do that."}.to_json
    end

  end

end