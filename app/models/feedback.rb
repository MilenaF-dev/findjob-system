class Feedback < ApplicationRecord
  belongs_to :job_application
  has_one :vacancy, through: :job_application

  has_one :answer, class_name: "Feedback", foreign_key: "answer_id"
  belongs_to :feedback, class_name: "Feedback", foreign_key: "answer_id", optional: true

  validates :reason, presence: true, unless: :answer_accepted?
  validates :start_date, presence: true, if: :accepted?
  validates :salary_proposal, presence: true, if: :salary_proposal_required?

  after_create :check_vacancy_filled, if: :answer_accepted?

  private

  def answer_accepted?
    accepted? && feedback.present?
  end

  def salary_proposal_required?
    accepted? && feedback.blank?
  end

  def check_vacancy_filled
    vacancy.update_filled!
  end
end
