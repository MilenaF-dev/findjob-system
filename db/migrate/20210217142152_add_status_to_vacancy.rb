class AddStatusToVacancy < ActiveRecord::Migration[6.1]
  def change
    add_column :vacancies, :status, :integer, default: 0, null: false
  end
end
