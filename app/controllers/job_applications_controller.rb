class JobApplicationsController < ApplicationController
  before_action :authenticate_user_or_candidate!, only: [:index]
  before_action :authenticate_candidate!, only: [:create]

  def index
    if candidate_signed_in?
      @job_applications = current_candidate.job_applications
    else
      @job_applications = current_user.company.job_applications
    end
  end

  def create
    vacancy = Vacancy.find(params[:vacancy_id])

    return flash[:notice] = t("job_applications.messages.already_created") if vacancy.candidates.include?(current_candidate)

    JobApplication.create(vacancy: vacancy, candidate: current_candidate)

    flash[:notice] = t("job_applications.messages.created")
    redirect_to vacancy_path(vacancy)
  end
end
