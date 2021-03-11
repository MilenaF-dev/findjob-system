class NotificationsMailer < ApplicationMailer
  def job_application_email(job_application)
    @vacancy = job_application.vacancy
    @company = @vacancy.company
    @candidate = job_application.candidate
    mail(to: @candidate.email, subject: "Candidatura realizada com sucesso")
  end

  def feedback_email(feedback)
    @feedback = feedback
    @vacancy = feedback.vacancy
    @company = @vacancy.company
    @candidate = feedback.job_application.candidate

    mail(to: @candidate.email, subject: "Retorno da empresa")
  end
end
