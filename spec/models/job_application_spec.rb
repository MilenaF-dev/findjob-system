require "rails_helper"

describe JobApplication do
  context "generate a object" do
    it "successfully" do
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

      expect(job_application.valid?).to eq(true)
    end
  end
end
