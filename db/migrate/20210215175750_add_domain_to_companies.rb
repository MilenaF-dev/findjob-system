class AddDomainToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :domain, :string
  end
end
