class DonationsController < ApplicationController
  def index
    candidate = Candidate.find(params[:candidate_id])

    # TODO this total is off, needs fixing
    donations = candidate.donations.joins('LEFT JOIN tweets ON donations.id = tweets.donation_id').select('donations.*, COUNT(tweets.id) as tweet_count').group('donations.id').where('amount > ?', 399).order(amount: :desc)

    render json: donations.to_json
  end
end