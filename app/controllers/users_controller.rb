class DonationsController < ApplicationController
  def index
    candidate = Candidate.find(params[:candidate_id])
    donations = candidate.donations.where('amount > ?', 399).order(amount: :desc)
    donations.to_json
    render json: donations.to_json
  end
end 