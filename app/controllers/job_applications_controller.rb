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
    
    @job_application = JobApplication.new(vacancy: vacancy, candidate: current_candidate)

    if @job_application.save
      NotificationsMailer.job_application_email(current_candidate, vacancy, vacancy.company).deliver_later
      flash[:notice] = t("job_applications.messages.created")
      redirect_to vacancy_path(vacancy)
    else
      flash[:notice] = t("job_applications.messages.already_created")
    end
  end
end
