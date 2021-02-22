class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.text :reason
      t.string :salary_proposal
      t.date :start_date
      t.boolean :accepted, null: false
      t.references :job_application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
