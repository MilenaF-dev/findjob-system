class Vacancy < ApplicationRecord
  belongs_to :company
  has_many :job_applications
  has_many :candidates, through: :job_applications

  enum status: { enabled: 0, disabled: 5 }

  validates :title, :nivel, :mandatory_requirements, :deadline, :total_vacancies, presence: true
end
