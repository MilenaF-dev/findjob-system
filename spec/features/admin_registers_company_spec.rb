require "rails_helper"

feature "Admin registers a company" do
  scenario "from index page" do
    visit root_path
    click_on "Empresas"

    expect(page).to have_link("Registrar empresa",
                              href: new_company_path)
  end

  scenario "successfully" do
    visit root_path
    click_on "Empresas"
    click_on "Registrar empresa"

    fill_in "Nome", with: "Algorich"
    attach_file "Logomarca", Rails.root.join("spec", "support", "logo_algorich.png")
    fill_in "Descrição", with: "Empresa de desenvolvimento de softwares"
    fill_in "Endereço completo", with: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ"
    fill_in "CNPJ", with: "123.234.333/000"
    fill_in "Site", with: "algorich.com.br"
    fill_in "Redes sociais", with: "@algorich"
    click_on "Criar Empresa"

    expect(current_path).to eq(company_path(Company.last))
    expect(page).to have_content("Algorich")
    expect(page).to have_css('img[src*="logo_algorich.png"]')
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).to have_content("Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ")
    expect(page).to have_content("123.234.333/000")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("@algorich")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    visit new_company_path

    fill_in "Nome", with: ""
    # attach_file "Logomarca", Rails.root()
    fill_in "Descrição", with: ""
    fill_in "Endereço completo", with: ""
    fill_in "CNPJ", with: ""
    fill_in "Site", with: ""
    fill_in "Redes sociais", with: ""
    click_on "Criar Empresa"

    expect(Company.count).to eq 0
    expect(page).to have_content("Não foi possível criar a empresa")
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Endereço completo não pode ficar em branco")
    expect(page).to have_content("CNPJ não pode ficar em branco")
    expect(page).to have_content("Site não pode ficar em branco")
  end

  scenario "and name and cnpj must be unique" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on "Registrar empresa"
    fill_in "Nome", with: "Algorich"
    fill_in "CNPJ", with: "123.234.333/000"
    click_on "Criar Empresa"

    expect(page).to have_content("Nome já está em uso")
    expect(page).to have_content("CNPJ já está em uso")
  end
end
