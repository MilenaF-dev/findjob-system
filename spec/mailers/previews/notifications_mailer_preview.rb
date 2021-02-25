# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview
  def job_application_email
    candidate = Candidate.first
    vacancy = Vacancy.first
    company = vacancy.company

    NotificationsMailer.job_application_email(candidate, vacancy, company)
  end

  def feedback_email
    feedback = Feedback.last

    NotificationsMailer.feedback_email(feedback)
  end
end
