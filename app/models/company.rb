class Company < ApplicationRecord
  has_one_attached :logo

  has_many :users
  has_many :vacancies
  has_many :job_applications, through: :vacancies

  validates :name, :description, :address, :cnpj, :site, presence: true
  validates :name, :cnpj, uniqueness: true

  scope :with_name, ->(search) { where("name like ?", "%#{search}%") }
end
