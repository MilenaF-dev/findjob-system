class Company < ApplicationRecord
  has_one_attached :logo

  has_many :users
  has_many :vacancies

  validates :name, :description, :address, :cnpj, :site, presence: true
  validates :name, :cnpj, uniqueness: true
end
