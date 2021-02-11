class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.text :address
      t.string :cnpj
      t.string :site
      t.string :social_networks

      t.timestamps
    end
  end
end
