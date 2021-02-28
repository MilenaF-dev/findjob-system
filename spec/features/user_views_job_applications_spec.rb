require "rails_helper"

feature "Employee views all applications" do
  scenario "must be signed in" do
    visit job_applications_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Precisa estar logado!")
  end

  scenario "have link" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)

    expect(page).to have_link("Candidaturas",
                              href: job_applications_path)
  end

  scenario "link disappears if employee is from other company" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    other_company = Company.create!(name: "Tech", description: "Empresa de desenvolvimento de softwares",
                                    address: "Avenida Alberto Lamego, Campos dos Goytacazes-RJ",
                                    cnpj: "567.289.345/010", site: "tech.com.br", social_networks: "@techch")
    employee = User.create!(email: "milena@email.com", password: "123456", company: other_company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)

    expect(page).not_to have_link("Candidaturas",
                                  href: job_applications_path)
  end

  scenario "link disappears if a candidate is signed in" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit company_path(company)

    expect(page).not_to have_link("Candidaturas",
                                  href: job_applications_path)
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)
    click_on "Candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content(vacancy.title)
    expect(page).to have_content(I18n.l(Date.today))
    expect(page).to have_content(candidate.full_name)
    expect(page).to have_content(candidate.email)
  end

  scenario "employee views candidate profile" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)
    click_on "Candidaturas"
    click_on candidate.full_name

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_content("Carlos Ferreira")
    expect(page).to have_content("84394789374")
    expect(page).to have_content("9999999")
    expect(page).to have_content("Tenho 25 anos, formada em Economia")
    expect(page).not_to have_link("Editar perfil")
  end

  scenario "can not view applications from another company" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    other_company = Company.create!(name: "Tech", description: "Empresa de desenvolvimento de softwares",
                                    address: "Avenida Alberto Lamego, Campos dos Goytacazes-RJ",
                                    cnpj: "567.289.345/010", site: "tech.com.br", social_networks: "@techch")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: other_company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)
    click_on "Candidaturas"

    expect(page).to have_content("Nenhuma candidatura")
    expect(page).not_to have_content(vacancy.title)
  end
end

feature "Employee views candidate's answer" do
  scenario "candidate declined proposal" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)
    answer = Feedback.create!(reason: "Salário oferecido abaixo do mercado", feedback: feedback,
                              job_application: job_application, accepted: false)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)
    click_on "Candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content(candidate.full_name)
    expect(page).to have_content("Proposta recusada")
    expect(page).to have_content(answer.reason)
  end

  scenario "candidate accepted proposal" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, level: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
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
    click_on "Candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content(candidate.full_name)
    expect(page).to have_content("Proposta aceita")
    expect(page).to have_content("22/03/2021")
  end
end
