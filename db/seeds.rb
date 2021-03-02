company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                          address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                          cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "algorich.com")
company.logo.attach(io: File.open(Rails.root.join("spec", "support", "logo_algorich.png")), filename: "logo_algorich.png")

other_company = Company.create!(name: "Americanas", description: "Varejo de diversos produtos",
                                address: "Rua Voluntários da Pátria, nº400, Centro, Campos dos Goytacazes-RJ",
                                cnpj: "789.546.333/000", site: "americanas.com.br", social_networks: "@americanas", domain: "americanas.com")

junior_vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                                 min_salary: 1500, max_salary: 3000, level: "Júnior",
                                 mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                                 deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

senior_vacancy = Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                                 min_salary: 8000, max_salary: 12000, level: "Sênior",
                                 mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                                 deadline: "22/10/2021", total_vacancies: "2", company: company, status: :enabled)

algorich_admin = User.create!(email: "milena@algorich.com", password: "123456", company: company, admin: true)

americanas_employee = User.create!(email: "clara@americanas.com", password: "123456", company: other_company, admin: false)

candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                              biography: "Tenho 25 anos, formado em Economia",
                              email: "carlos@mail.com", password: "123456")

job_application = JobApplication.create!(vacancy: junior_vacancy, candidate: candidate)

feedback = Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                            start_date: "22/07/2021", job_application: job_application, accepted: true)

answer = Feedback.create!(reason: "Salário oferecido abaixo do mercado", feedback: feedback,
                          job_application: job_application, accepted: false)
