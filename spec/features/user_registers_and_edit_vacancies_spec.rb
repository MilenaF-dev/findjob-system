require "rails_helper"

feature "User registers a vacancy" do
  scenario "must be signed in" do
    visit new_vacancy_path

    expect(current_path).to eq new_user_session_path
  end

  scenario "from index page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(page).to have_link("Cadastrar uma vaga",
                              href: new_vacancy_path)
  end

  scenario "button disappers if employee is not logged" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(page).not_to have_link("Cadastrar uma vaga",
                                  href: new_vacancy_path)
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
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
    fill_in "Total de vagas", with: 7
    click_on "Criar Vaga"

    expect(current_path).to eq(vacancy_path(Vacancy.last))
    expect(page).to have_content("Dev Júnior")
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
    expect(page).to have_content("Júnior")
    expect(page).to have_content("De R$ 1.500,00 até R$ 3.000,00")
    expect(page).to have_content("Conhecimentos em Ruby, Rails, SQLite")
    expect(page).to have_content("22/10/2021")
    expect(page).not_to have_link("Aplicar para esta vaga")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit new_vacancy_path

    fill_in "Título", with: ""
    fill_in "Descrição", with: ""
    fill_in "Nível", with: ""
    fill_in "De", with: nil
    fill_in "Até", with: nil
    fill_in "Requisitos obrigatórios", with: ""
    fill_in "Data limite", with: ""
    fill_in "Total de vagas", with: ""
    click_on "Criar Vaga"

    expect(Vacancy.count).to eq 0
    expect(page).to have_content("Não foi possível criar a vaga")
    expect(page).to have_content("Título não pode ficar em branco")
    expect(page).to have_content("Nível não pode ficar em branco")
    expect(page).to have_content("Requisitos obrigatórios não pode ficar em branco")
    expect(page).to have_content("Data limite não pode ficar em branco")
    expect(page).to have_content("Total de vagas não pode ficar em branco")
  end

  scenario "and return to company page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit root_path
    click_on "Empresas"
    click_on company.name
    click_on "Cadastrar uma vaga"
    click_on "Voltar"

    expect(current_path).to eq(company_path(company))
  end
end

feature "User edit a existent vacancy" do
  scenario "must be signed in" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)

    visit edit_vacancy_path(vacancy)

    expect(current_path).to eq new_user_session_path
  end

  scenario "from index page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title

    expect(page).to have_link("Editar",
                              href: edit_vacancy_path(vacancy))
  end

  scenario "button disappers if employee is not logged" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title

    expect(page).not_to have_link("Editar",
                                  href: edit_vacancy_path(vacancy))
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit vacancy_path(vacancy)
    click_on "Editar"

    fill_in "Título", with: "Dev"
    fill_in "De", with: 1000
    fill_in "Data limite", with: "30/08/2022"
    click_on "Atualizar Vaga"

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).to have_content("Dev")
    expect(page).to have_content("De R$ 1.000,00 até R$ 3.000,0")
    expect(page).to have_content("30/08/2022")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit edit_vacancy_path(vacancy)

    fill_in "Título", with: ""
    fill_in "Descrição", with: ""
    fill_in "Nível", with: ""
    fill_in "De", with: nil
    fill_in "Até", with: nil
    fill_in "Requisitos obrigatórios", with: ""
    fill_in "Data limite", with: ""
    fill_in "Total de vagas", with: ""
    click_on "Atualizar Vaga"

    expect(page).to have_content("Não foi possível editar a vaga")
    expect(page).to have_content("Título não pode ficar em branco")
    expect(page).to have_content("Nível não pode ficar em branco")
    expect(page).to have_content("Requisitos obrigatórios não pode ficar em branco")
    expect(page).to have_content("Data limite não pode ficar em branco")
    expect(page).to have_content("Total de vagas não pode ficar em branco")
  end

  scenario "and return to vacancy page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title
    click_on "Editar"
    click_on "Voltar"

    expect(current_path).to eq(vacancy_path(vacancy))
  end

  # Passar testes de request para outro arquivo
  scenario "edit request protected if employee is from other company", type: :request do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    other_company = Company.create!(name: "Tech", description: "Empresa de desenvolvimento",
                                    address: "Campos dos Goytacazes-RJ",
                                    cnpj: "543.123.678/010", site: "tech.com.br", social_networks: "@tech.dev", domain: "dev.com")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              level: "Júnior", min_salary: 1500, max_salary: 3000,
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 3, company: company, status: :enabled)
    employee = User.create!(email: "milena@dev.com", password: "123456", company: other_company, admin: true)

    login(employee.email, "123456")
    get edit_vacancy_path(vacancy)

    expect(response.status).to eq(404)
  end

  def login(email, password)
    post user_session_path, params: { user: { email: email, password: password } }
  end
end
