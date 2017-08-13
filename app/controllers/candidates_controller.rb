class CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all.order(:last_name)

  end

  def donations
    candidate_id = params[:candidate_id]
    candidate = Candidate.find(candidate_id)
    donations = candidate.donations
    donations.to_json
    render json: donations.to_json
  end

end