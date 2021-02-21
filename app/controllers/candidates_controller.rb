class CandidatesController < ApplicationController
  before_action :authenticate_user_or_candidate!, only: [:show]

  def show
    @candidate = Candidate.find(params[:id])
  end
end
