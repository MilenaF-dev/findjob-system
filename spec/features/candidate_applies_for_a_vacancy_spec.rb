require "rails_helper"

feature "Candidate applies for a vacancy" do
  scenario "have link to apply" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title

    expect(current_path).to eq(vacancy_path(vacancy))
    expect(page).to have_link("Aplicar para esta vaga",
                              href: vacancy_job_applications_path(vacancy))
  end

  scenario "must be signed in" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit vacancy_path(vacancy)
    click_on "Aplicar para esta vaga"

    expect(current_path).to eq(new_candidate_session_path)
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit vacancy_path(vacancy)
    click_on "Aplicar para esta vaga"

    vacancy.reload
    expect(current_path).to eq(vacancy_path(vacancy))
    expect(JobApplication.last.vacancy).to eq(vacancy)
    expect(page).to have_content("Candidatura realizada com sucesso!")
  end

  scenario "button disappers if candidate already applied" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)

    login_as candidate, scope: :candidate
    visit vacancy_path(vacancy)

    expect(page).not_to have_link("Aplicar para esta vaga")
  end

  scenario "apply request protected if candidate already applied", type: :request do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)

    login_as candidate, scope: :candidate
    post vacancy_job_applications_path(vacancy)

    expect(flash[:notice]).to match("Você já se candidatou para esta vaga")
  end
end

feature "Candidate views his applications" do
  scenario "must be signed in" do
    visit job_applications_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Precisa estar logado!")
  end

  scenario "have link" do
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit root_path

    expect(page).to have_link("Minhas candidaturas",
                              href: job_applications_path)
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_link(vacancy.title)
    expect(page).to have_content(I18n.l(Date.today))
  end

  scenario "can not view other candidate's applications" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    other_candidate = Candidate.create!(full_name: "José Ferreira", cpf: "94832904832", phone: "999998888",
                                        biography: "Tenho 22 anos, formada em Engenharia",
                                        email: "jose@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)

    login_as other_candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"

    expect(page).to have_content("Nenhuma candidatura")
    expect(page).not_to have_content(vacancy.title)
  end
end

feature "Candidate views the company's answer for his application" do
  scenario "view the refusal" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Perfil não se enquadra no perfil da empresa", job_application: job_application, accepted: false)

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_link(vacancy.title)
    expect(page).to have_content(I18n.l(Date.today))
    expect(page).to have_content(feedback.reason)
  end

  scenario "view the proposal" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_link(vacancy.title)
    expect(page).to have_content(I18n.l(Date.today))
    expect(page).to have_content(feedback.reason)
    expect(page).to have_content(feedback.salary_proposal)
    expect(page).to have_content("22/03/2021")
  end
end

feature "Candidate replies the company's proposal" do
  scenario "have links" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_link(vacancy.title)
    expect(page).to have_content(I18n.l(Date.today))
    expect(page).to have_content(feedback.reason)
    expect(page).to have_content(feedback.salary_proposal)
    expect(page).to have_content("22/03/2021")
    expect(page).to have_link("Recusar proposta")
    expect(page).to have_link("Aceitar proposta")
  end

  scenario "refuses the proposal" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"
    click_on "Recusar proposta"

    fill_in "Motivo", with: "Proposta salarial abaixo do esperado"
    click_on "Enviar resposta"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content("Você recusou essa proposta!")
  end

  scenario "accepts the proposal" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Minhas candidaturas"
    click_on "Aceitar proposta"

    fill_in "Data de início", with: "22/03/2021"
    click_on "Enviar resposta"

    expect(current_path).to eq(job_applications_path)
    expect(page).to have_content("Parabéns! Você aceitou essa proposta!")
  end

  scenario "if accepts proposal start date can not be blank" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)

    login_as candidate, scope: :candidate
    visit company_path(company)
    click_on "Minhas candidaturas"
    click_on "Aceitar proposta"

    fill_in "Data de início", with: ""
    click_on "Enviar resposta"

    expect(page).to have_content("Data de início não pode ficar em branco")
  end

  scenario "if refuses proposal reason can not be blank" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")
    job_application = JobApplication.create!(vacancy: vacancy, candidate: candidate)
    feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                                start_date: "22/03/2021", job_application: job_application, accepted: true)

    login_as candidate, scope: :candidate
    visit company_path(company)
    click_on "Minhas candidaturas"
    click_on "Recusar proposta"

    fill_in "Motivo", with: ""
    click_on "Enviar resposta"

    expect(page).to have_content("Motivo não pode ficar em branco")
  end

  scenario "links disappear if the answer was already sent" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
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

    login_as candidate, scope: :candidate
    visit job_applications_path

    expect(page).not_to have_link("Recusar proposta")
    expect(page).not_to have_link("Aceitar proposta")
  end
end
