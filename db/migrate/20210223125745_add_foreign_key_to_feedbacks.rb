class AddForeignKeyToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_reference :feedbacks, :answer, index: true
  end
end
