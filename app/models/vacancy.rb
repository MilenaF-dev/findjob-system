class Vacancy < ApplicationRecord
  belongs_to :company

  validates :title, :nivel, :mandatory_requirements, :deadline, :total_vacancies, presence: true
end
