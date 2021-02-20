class CreateJobApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :job_applications do |t|
      t.references :candidate, null: false, foreign_key: true
      t.references :vacancy, null: false, foreign_key: true

      t.timestamps
    end
  end
end
