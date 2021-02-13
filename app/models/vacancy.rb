class Vacancy < ApplicationRecord
  serialize :salary_range

  belongs_to :company
end
