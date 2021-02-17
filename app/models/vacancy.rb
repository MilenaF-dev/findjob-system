class Vacancy < ApplicationRecord
  belongs_to :company

  enum status: { enable: 0, disable: 5 }

  validates :title, :nivel, :mandatory_requirements, :deadline, :total_vacancies, presence: true
end
