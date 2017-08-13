class DonationsController < ApplicationController
  def index
    candidate = Candidate.find(params[:candidate_id])
    donations = candidate.donations
    donations.to_json
    render json: donations.to_json
  end
end