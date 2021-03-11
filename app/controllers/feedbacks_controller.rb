class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback = Feedback.new(accepted: params[:accept] == "true")
  end

  def create
    job_application = JobApplication.find(params[:job_application_id])

    @feedback = Feedback.new(feedback_params.merge(job_application: job_application))

    if @feedback.save
      NotificationsMailer.feedback_email(@feedback).deliver_later
      redirect_to job_applications_path
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:reason, :salary_proposal, :start_date, :accepted)
  end
end
