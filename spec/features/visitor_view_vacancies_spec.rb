require "rails_helper"

feature "Visitor view available vacancies" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"

    expect(current_path).to eq(vacancies_path)
    expect(page).to have_content("Dev Júnior")
    expect(page).to have_content("Júnior")
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Dev Sênior")
    expect(page).to have_content("Sênior")
    expect(page).to have_content("Algorich")
  end

  scenario "and view details" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).to have_content("Dev Júnior")
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
    expect(page).to have_content("Júnior")
    expect(page).to have_content("De R$ 1.500,00 até R$ 3.000,00")
    expect(page).to have_content("Conhecimentos em Ruby, Rails, SQLite")
    expect(page).to have_content("22/10/2021")
  end

  scenario "and no available vacancies" do
    visit root_path
    click_on "Vagas disponíveis"

    expect(page).to have_content("Nenhuma vaga disponível")
  end

  scenario "visitor just see enable vacancies" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :disabled)

    visit root_path
    click_on "Vagas disponíveis"

    expect(current_path).to eq(vacancies_path)
    expect(page).to have_content("Dev Júnior")
    expect(page).to have_content("Júnior")
    expect(page).to have_content("Algorich")
    expect(page).not_to have_content("Dev Sênior")
    expect(page).not_to have_content("Sênior")
  end

  scenario "visitor do not see vacancy with deadline exceeded" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2020", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"

    expect(current_path).to eq(vacancies_path)
    expect(page).not_to have_content("Dev Júnior")
    expect(page).not_to have_content("Júnior")
    expect(page).not_to have_content("Algorich")
  end

  scenario "and return to home page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Vagas disponíveis"
    click_on "Voltar"

    expect(current_path).to eq root_path
  end

  scenario "and return to vacancies page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title
    click_on "Voltar"

    expect(current_path).to eq vacancies_path
  end

  scenario "only enable vacancies from a company" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :disabled)

    visit root_path
    click_on "Empresas"
    click_on company.name

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Vagas desta empresa")
    expect(page).to have_link("Dev Júnior")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
    expect(page).not_to have_link("Dev Sênior")
    expect(page).not_to have_content("Vaga de desenvolvidor sênior Ruby on Rails")
  end

  scenario "only employees can see number of vacancies" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: 7, company: company, status: :enabled)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit vacancy_path(vacancy)

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).to have_content("Dev Júnior")
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
    expect(page).to have_content("Júnior")
    expect(page).to have_content("De R$ 1.500,00 até R$ 3.000,00")
    expect(page).to have_content("Conhecimentos em Ruby, Rails, SQLite")
    expect(page).to have_content("22/10/2021")
    expect(page).to have_content(7)
  end

  scenario "and only employees can see vacancies with deadline exceeded" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2020", total_vacancies: "3", company: company, status: :enabled)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit company_path(company)

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content("Dev Júnior (Vaga expirada")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
    expect(page).not_to have_link("Desabilitar vaga")
  end
end

feature "Visitor search for vacancies" do
  scenario "for vacancies title" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :enabled)
    Vacancy.create!(title: "Techlead", description: "Vaga para atuar como líder técnico",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 8 anos",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"
    fill_in "Pesquise por vagas", with: "Dev"
    click_on "Pesquisar"

    expect(current_path).to eq(vacancies_path)
    expect(page).to have_link("Dev Júnior")
    expect(page).to have_content("Júnior")
    expect(page).to have_link("Dev Sênior")
    expect(page).to have_content("Sênior")
    expect(page).not_to have_link("Techlead")
  end

  scenario "search for vacancies level" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, level: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :enabled)
    Vacancy.create!(title: "Techlead", description: "Vaga para atuar como líder técnico",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 8 anos",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit vacancies_path
    fill_in "Pesquise por vagas", with: "Sênior"
    click_on "Pesquisar"

    expect(current_path).to eq(vacancies_path)
    expect(page).to have_link("Techlead")
    expect(page).to have_content("Sênior")
    expect(page).to have_link("Dev Sênior")
    expect(page).not_to have_link("Dev Júnior")
    expect(page).not_to have_content("Júnior")
  end

  scenario "no results found" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Techlead", description: "Vaga para atuar como líder técnico",
                    min_salary: 8000, max_salary: 12000, level: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 8 anos",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit vacancies_path
    fill_in "Pesquise por vagas", with: "Dev"
    click_on "Pesquisar"

    expect(current_path).to eq(vacancies_path)
    expect(page).to have_content("Nenhuma vaga disponível")
  end
end

feature "Vacancy that was filled is not available" do
  scenario "vacancy is disabled if it was filled" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "1", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)
    answer = Feedback.create!(start_date: "22/03/2021", feedback: feedback,
                              job_application: job_application, accepted: true)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)
    click_on vacancy.title

    expect(page).to have_content("Dev Júnior (Vaga desabilitada)")
    expect(page).to have_content("Vaga foi desabilitada automaticamente porque já foi preenchida")
  end

  scenario "visitor can not see vacancy filled" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "1", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)
    answer = Feedback.create!(start_date: "22/03/2021", feedback: feedback,
                              job_application: job_application, accepted: true)

    visit root_path
    click_on "Vagas disponíveis"

    expect(page).not_to have_content("Dev Júnior")
  end

  scenario "and only employees can see vacancies filled" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "1", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)
    answer = Feedback.create!(start_date: "22/03/2021", feedback: feedback,
                              job_application: job_application, accepted: true)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee
    visit company_path(company)

    expect(page).to have_content("Dev Júnior (Vaga desabilitada)")
    expect(page).to have_content("Vaga de desenvolvidor júnior Ruby on Rails")
  end
end
