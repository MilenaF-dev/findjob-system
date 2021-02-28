require "rails_helper"

describe Company do
  context "validation" do
    it "attributes cannot be blank" do
      company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                                address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                                cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "")
      vacancy = Vacancy.new(company: company)

      expect(vacancy.valid?).to eq false
      expect(vacancy.errors.count).to eq 5
    end

    it "description, min and max salary are optional" do
      company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                                address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                                cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "")
      vacancy = Vacancy.new(title: "Dev Júnior", level: "Júnior",
                            mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                            deadline: "22/10/2021", total_vacancies: "3", company: company)

      expect(vacancy.valid?).to eq(true)
    end

    it "error messages are in portuguese" do
      company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                                address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                                cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "")
      vacancy = Vacancy.new(company: company)

      vacancy.valid?

      expect(vacancy.errors[:title]).to include("não pode ficar em branco")
      expect(vacancy.errors[:level]).to include("não pode ficar em branco")
      expect(vacancy.errors[:mandatory_requirements]).to include("não pode ficar em " \
                                                         "branco")
      expect(vacancy.errors[:deadline]).to include("não pode ficar em" \
                                           " branco")
      expect(vacancy.errors[:total_vacancies]).to include("não pode ficar em" \
                                                  " branco")
    end
  end
end
