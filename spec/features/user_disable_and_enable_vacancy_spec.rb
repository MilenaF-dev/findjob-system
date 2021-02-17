require "rails_helper"

feature "User disable vacancy" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              nivel: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enable)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on vacancy.title
    click_on "Desabilitar vaga"

    vacancy.reload
    expect(page).to have_content("Dev Júnior (Vaga desabilitada)")
    expect(vacancy).to be_disable
  end

  scenario "does not view button if vacancy is disable" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              nivel: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :disable)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit vacancy_path(vacancy)

    expect(page).not_to have_link("Desabilitar vaga")
    expect(page).to have_link("Habilitar vaga")
  end

  scenario "does not view button if employee is not logged" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              nivel: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enable)

    visit vacancy_path(vacancy)

    expect(page).not_to have_link("Desabilitar vaga")
  end
end

feature "User enable vacancy" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              nivel: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :disable)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on vacancy.title
    click_on "Habilitar vaga"

    vacancy.reload
    expect(page).to have_content("Dev Júnior")
    expect(vacancy).to be_enable
  end

  scenario "does not view button if vacancy is enable" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              nivel: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enable)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit vacancy_path(vacancy)

    expect(page).to have_link("Desabilitar vaga")
    expect(page).not_to have_link("Habilitar vaga")
  end

  scenario "does not view button if employee is not logged" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              nivel: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :disable)

    visit vacancy_path(vacancy)

    expect(page).not_to have_link("Habilitar vaga")
  end
end
