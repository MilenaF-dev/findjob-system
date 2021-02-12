require "rails_helper"

describe Company do
  context "validation" do
    it "attributes cannot be blank" do
      company = Company.new()

      expect(company.valid?).to eq false
      expect(company.errors.count).to eq 5
    end

    it "social_networks and logo are optional" do
      company = Company.new(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                            address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                            cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "")

      expect(company.valid?).to eq(true)
    end

    it "error messages are in portuguese" do
      company = Company.new

      company.valid?

      expect(company.errors[:name]).to include("não pode ficar em branco")
      expect(company.errors[:description]).to include("não pode ficar em branco")
      expect(company.errors[:address]).to include("não pode ficar em " \
                                          "branco")
      expect(company.errors[:cnpj]).to include("não pode ficar em" \
                                       " branco")
      expect(company.errors[:site]).to include("não pode ficar em" \
                                       " branco")
    end

    it "name and cnpj must be uniq" do
      Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                      address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                      cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
      company = Company.new(name: "Algorich", cnpj: "123.234.333/000")

      company.valid?

      expect(company.errors[:name]).to include("já está em uso")
      expect(company.errors[:cnpj]).to include("já está em uso")
    end
  end
end
