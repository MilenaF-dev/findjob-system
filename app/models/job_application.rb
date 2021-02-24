class JobApplication < ApplicationRecord
  belongs_to :candidate
  belongs_to :vacancy

  has_one :feedback
  has_one :answer, through: :feedback

  scope :approved, -> { includes(:answer).where(answer: { accepted: true }) }

  def reviewed?
    feedback.present?
  end

  def accepted?
    feedback.accepted?
  end
end
