class CreateVacancies < ActiveRecord::Migration[6.1]
  def change
    create_table :vacancies do |t|
      t.string :title
      t.text :description
      t.decimal :min_salary
      t.decimal :max_salary
      t.string :nivel
      t.text :mandatory_requirements
      t.date :deadline
      t.integer :total_vacancies
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
