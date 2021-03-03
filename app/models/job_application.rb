class JobApplication < ApplicationRecord
  belongs_to :candidate
  belongs_to :vacancy

  has_one :feedback
  has_one :answer, through: :feedback

  validates :candidate_id, uniqueness: { scope: :vacancy_id }
  
  scope :approved, -> { includes(:answer).where(answer: { accepted: true }) }

  def reviewed?
    feedback.present?
  end

  def accepted?
    feedback.accepted?
  end
end
