require "rails_helper"

feature "User registers a vacancy" do
  scenario "from index page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(page).to have_link("Cadastrar uma vaga",
                              href: new_vacancy_path)
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on "Cadastrar uma vaga"

    fill_in "Título", with: "Dev Júnior"
    fill_in "Descrição", with: "Vaga de desenvolvidor júnior Ruby on Rails"
    fill_in "Nível", with: "Júnior"
    fill_in "De", with: 1500
    fill_in "Até", with: 3000
    fill_in "Requisitos obrigatórios", with: "Conhecimentos em Ruby, Rails, SQLite"
    fill_in "Data limite", with: "22/10/2021"
    fill_in "Total de vagas", with: 3
    click_on "Criar Vaga"

    expect(current_path).to eq(vacancy_path(Vacancy.last))
    expect(page).to have_content("Dev Júnior")
    # expect(page).to have_content("Algorich")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
    expect(page).to have_content("Júnior")
    expect(page).to have_content("De R$ 1.500,00 até R$ 3.000,00")
    expect(page).to have_content("Conhecimentos em Ruby, Rails, SQLite")
    expect(page).to have_content("22/10/2021")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    visit new_vacancy_path

    fill_in "Título", with: ""
    fill_in "Descrição", with: ""
    fill_in "Nível", with: ""
    fill_in "De", with: nil
    fill_in "Até", with: nil
    fill_in "Requisitos obrigatórios", with: ""
    fill_in "Data limite", with: ""
    click_on "Criar Vaga"

    expect(Vacancy.count).to eq 0
    expect(page).to have_content("Não foi possível criar a vaga")
    expect(page).to have_content("Título não pode ficar em branco")
    expect(page).to have_content("Nível não pode ficar em branco")
    expect(page).to have_content("Requisitos obrigatórios não pode ficar em branco")
    expect(page).to have_content("Data limite não pode ficar em branco")
    expect(page).to have_content("Total de vagas não pode ficar em branco")
  end
end
