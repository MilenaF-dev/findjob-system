class Vacancy < ApplicationRecord
  belongs_to :company
  has_many :job_applications
  has_many :candidates, through: :job_applications

  enum status: { enabled: 0, disabled: 5 }

  validates :title, :level, :mandatory_requirements, :deadline, :total_vacancies, presence: true

  scope :future, -> { where("deadline >= ?", Date.current) }
  scope :with_title_or_level, ->(search) { where("title like :search OR level like :search", search: "%#{search}%") }

  def filled?
    job_applications.approved.size >= total_vacancies
  end

  def update_filled!
    update!(status: :disabled) if filled?
  end
end
