class CandidatesController < ApplicationController
  
  def index
    
    @candidates = Candidate.joins(:committees).joins(:donations).select('candidates.*, SUM(donations.amount) as total_donations').group('candidates.id').order(:last_name)

  end

end