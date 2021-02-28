class RenameVacanciesNivel < ActiveRecord::Migration[6.1]
  def change
    rename_column :vacancies, :nivel, :level
  end
end
