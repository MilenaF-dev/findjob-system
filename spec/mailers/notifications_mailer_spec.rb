require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe "job application email" do
    let(:candidate) do
      Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                        biography: "Tenho 25 anos, formada em Economia",
                        email: "carlos@mail.com", password: "123456")
    end

    let(:company) do
      Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                      address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                      cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    end

    let(:vacancy) do
      Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                      min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                      mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                      deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    end

    let(:mail) { described_class.job_application_email(candidate, vacancy, company).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq("Candidatura realizada com sucesso")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([candidate.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["notifications@findjob.com"])
    end

    it "includes full name" do
      expect(mail.body.encoded).to match(candidate.full_name)
    end

    it "includes vacancy title" do
      expect(mail.body.encoded).to match(vacancy.title)
    end

    it "includes company name" do
      expect(mail.body.encoded).to match(company.name)
    end
  end

  describe "feedback email" do
    let(:candidate) do
      Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                        biography: "Tenho 25 anos, formada em Economia",
                        email: "carlos@mail.com", password: "123456")
    end

    let(:company) do
      Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                      address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                      cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    end

    let(:vacancy) do
      Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                      min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                      mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                      deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    end

    let(:job_application) { JobApplication.create!(vacancy: vacancy, candidate: candidate) }

    let(:feedback_accepted) do
      Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                       start_date: "22/03/2021", job_application: job_application, accepted: true)
    end

    let(:mail) { described_class.feedback_email(feedback_accepted).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq("Retorno da empresa")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([candidate.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["notifications@findjob.com"])
    end

    it "includes full name" do
      expect(mail.body.encoded).to match(candidate.full_name)
    end

    context "job application was accepted" do
      it "includes vacancy title" do
        expect(mail.body.encoded).to match(vacancy.title)
      end

      it "includes company name" do
        expect(mail.body.encoded).to match(company.name)
      end

      it "includes congratulations" do
        expect(mail.body.encoded).to match("Parabéns")
      end
    end

    context "job application was declined" do
      let(:feedback_not_accepted) do
        Feedback.create!(reason: "Gostamos muito do seu perfil", salary_proposal: "2500",
                         start_date: "22/03/2021", job_application: job_application, accepted: false)
      end

      let(:mail_denied) { described_class.feedback_email(feedback_not_accepted).deliver_now }

      it "includes unfortunately" do
        expect(mail_denied.body.encoded).to match("Infelizmente")
      end
    end
  end
end
