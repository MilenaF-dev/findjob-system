class AnswerController < ApplicationController
  #   before_action :authenticate_candidate!

  def new
    @feedback = Feedback.find(params[:feedback_id])
    @answer = Feedback.new(start_date: @feedback.start_date, accepted: params[:accept] == "true")
  end

  def create
    @feedback = Feedback.find(params[:feedback_id])
    @answer = Feedback.new(answer_params.merge(feedback: @feedback, job_application: @feedback.job_application))

    if @answer.save
      redirect_to job_applications_path
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:feedback).permit(:reason, :start_date, :accepted)
  end
end
