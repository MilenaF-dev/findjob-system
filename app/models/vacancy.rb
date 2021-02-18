class Vacancy < ApplicationRecord
  belongs_to :company

  enum status: { enabled: 0, disabled: 5 }

  validates :title, :nivel, :mandatory_requirements, :deadline, :total_vacancies, presence: true
end
