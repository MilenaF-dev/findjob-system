require "rails_helper"

feature "Employee evaluate applications" do
  scenario "musted be signed in" do
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

    visit new_job_application_feedback_path(job_application)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario "have links" do
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
    expect(page).to have_content(candidate.full_name)
    expect(page).to have_link("Recusar")
    expect(page).to have_link("Enviar proposta")
  end

  scenario "refuse application" do
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
    click_on "Recusar"

    fill_in "Motivo", with: "Perfil não se enquadra no perfil da empresa"
    click_on "Enviar feedback"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content("Recusada")
  end

  scenario "send proposal" do
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
    click_on "Enviar proposta"

    fill_in "Motivo", with: "Parabéns vocé foi aprovado em nosso processo seletivo!"
    fill_in "Proposta salarial", with: "3000"
    fill_in "Data de início", with: "22/03/2021"
    click_on "Enviar feedback"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content("Proposta enviada")
  end

  scenario "attributes can not be blank" do
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
    click_on "Enviar proposta"

    fill_in "Motivo", with: ""
    fill_in "Proposta salarial", with: ""
    fill_in "Data de início", with: ""
    click_on "Enviar feedback"

    expect(page).to have_content("Motivo não pode ficar em branco")
    expect(page).to have_content("Proposta salarial não pode ficar em branco")
    expect(page).to have_content("Data de início não pode ficar em branco")
  end

  scenario "links disappear if the application was already evaluated" do
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
    feedback = Feedback.create!(reason: "Perfil não se enquadra no perfil da empresa", job_application: job_application, accepted: false)
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit job_applications_path

    expect(page).not_to have_link("Recusar")
    expect(page).not_to have_link("Enviar proposta")
  end
end

feature "Employee views job applications received for vacancy" do
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
    click_on vacancy.title

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).to have_content(candidate.full_name)
    expect(page).to have_content(candidate.email)
    expect(page).to have_content(I18n.l(Date.today))
    expect(page).to have_content("Pendente de avaliação")
  end

  scenario "and no job application" do
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
    employee = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as employee, scope: :user
    visit company_path(company)
    click_on vacancy.title

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).not_to have_content(candidate.full_name)
    expect(page).to have_content("Nenhuma candidatura")
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
    click_on vacancy.title

    expect(current_path).to eq(vacancy_path(vacancy))
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
    click_on vacancy.title

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).to have_content(candidate.full_name)
    expect(page).to have_content("Proposta aceita")
    expect(page).to have_content("22/03/2021")
  end
end
