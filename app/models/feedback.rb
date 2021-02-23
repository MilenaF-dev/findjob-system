class Feedback < ApplicationRecord
  belongs_to :job_application

  has_one :answer, class_name: "Feedback", foreign_key: "answer_id"
  belongs_to :feedback, class_name: "Feedback", foreign_key: "answer_id", optional: true

  validates :reason, presence: true, unless: :reason_required?
  validates :start_date, presence: true, if: :accepted?
  validates :salary_proposal, presence: true, if: :salary_proposal_required?

  private

  def reason_required?
    accepted? && feedback.present?
  end

  def salary_proposal_required?
    accepted? && feedback.blank?
  end
end
