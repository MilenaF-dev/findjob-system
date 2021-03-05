require "rails_helper"

feature "Visitor view companies" do
  scenario "successfully" do
    Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                    address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                    cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Company.create!(name: "Americanas", description: "Varejo de diversos produtos",
                    address: "Rua Voluntários da Pátria, nº400, Centro, Campos dos Goytacazes-RJ",
                    cnpj: "789.546.333/000", site: "americanas.com.br", social_networks: "@americanas")

    visit root_path
    click_on "Empresas"

    expect(current_path).to eq(companies_path)
    expect(page).to have_content("Algorich")
    expect(page).to have_content("123.234.333/000")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("Americanas")
    expect(page).to have_content("789.546.333/000")
    expect(page).to have_content("americanas.com.br")
  end

  scenario "and view details" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Company.create!(name: "Americanas", description: "Varejo de diversos produtos",
                    address: "Rua Voluntários da Pátria, nº400, Centro, Campos dos Goytacazes-RJ",
                    cnpj: "789.546.333/000", site: "americanas.com.br", social_networks: "@americanas")

    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).to have_content("Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ")
    expect(page).to have_content("123.234.333/000")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("@algorich")
  end

  scenario "and no companies are created" do
    visit root_path
    click_on "Empresas"

    expect(page).to have_content("Nenhuma empresa cadastrada")
  end

  scenario "and return to home page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on "Home"

    expect(current_path).to eq root_path
  end

  scenario "and return to companies page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on "Voltar"

    expect(current_path).to eq companies_path
  end
end

feature "Visitor search for companies name" do
  scenario "successfully" do
    Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                    address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                    cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Company.create!(name: "Americanas", description: "Varejo de diversos produtos",
                    address: "Rua Voluntários da Pátria, nº400, Centro, Campos dos Goytacazes-RJ",
                    cnpj: "789.546.333/000", site: "americanas.com.br", social_networks: "@americanas")

    visit root_path
    click_on "Empresas"
    fill_in "Pesquise por empresas", with: "Algorich"
    click_on "Pesquisar"

    expect(current_path).to eq(companies_path)
    expect(page).to have_link("Algorich")
    expect(page).to have_content("123.234.333/000")
    expect(page).not_to have_link("Americanas")
    expect(page).not_to have_content("789.546.333/000")
  end

  scenario "no results found" do
    Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                    address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                    cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit companies_path
    fill_in "Pesquise por empresas", with: "Americanas"
    click_on "Pesquisar"

    expect(current_path).to eq(companies_path)
    expect(page).to have_content("Nenhuma empresa cadastrada")
  end
end
