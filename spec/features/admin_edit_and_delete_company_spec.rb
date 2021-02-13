require "rails_helper"

feature "Admin edit a existent company" do
  scenario "from index page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(page).to have_link("Editar",
                              href: edit_company_path(company))
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on "Editar"

    fill_in "Nome", with: "Algorich"
    fill_in "Descrição", with: "Empresa de desenvolvimento de softwares"
    fill_in "Endereço completo", with: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ"
    fill_in "CNPJ", with: "123.234.333/000"
    fill_in "Site", with: "algorich.com.br"
    fill_in "Redes sociais", with: "@algorich"
    click_on "Atualizar Empresa"

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).to have_content("Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ")
    expect(page).to have_content("123.234.333/000")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("@algorich")
    expect(page).to have_link("Voltar")
  end

  scenario "and return to company page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on "Editar"
    click_on "Voltar"

    expect(current_path).to eq company_path(company)
  end
end

feature "Admin delete a existent company" do
  scenario "have link" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(page).to have_selector("a[href='#{company_path(company)}'][data-method='delete']", text: "Apagar")
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit company_path(company)
    click_on "Apagar"

    expect(current_path).to eq(companies_path)
    expect(page).to have_content("Empresa apagada com sucesso!")
    expect(page).to_not have_content("Algorich")
  end
end
