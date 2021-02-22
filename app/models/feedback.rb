class Feedback < ApplicationRecord
  belongs_to :job_application

  validates :reason, presence: true
  validates :salary_proposal, :start_date, presence: true, if: :accepted?
end
