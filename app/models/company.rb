class Company < ApplicationRecord
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize: "100x100"
  end

  validates :name, :description, :address, :cnpj, :site, presence: true
  validates :name, :cnpj, uniqueness: true
end
