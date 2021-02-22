class JobApplication < ApplicationRecord
  belongs_to :candidate
  belongs_to :vacancy

  has_one :feedback

  def reviewed?
    feedback.present?
  end

  def accepted?
    feedback.accepted?
  end
end
