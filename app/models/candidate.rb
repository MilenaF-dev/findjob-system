class Candidate < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :job_applications
  has_many :vacancies, through: :job_applications

  validates :full_name, :cpf, :phone, presence: true
  validates :cpf, uniqueness: true
end