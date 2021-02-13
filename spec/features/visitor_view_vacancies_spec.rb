require "rails_helper"

feature "Visitor view available vacancies" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, nivel: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company)

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
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company)

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

  scenario "and return to home page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    vacancy = Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                              min_salary: 1500, max_salary: 30000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company)

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
                              min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                              mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                              deadline: "22/10/2021", total_vacancies: "3", company: company)

    visit root_path
    click_on "Vagas disponíveis"
    click_on vacancy.title
    click_on "Voltar"

    expect(current_path).to eq vacancies_path
  end
end
