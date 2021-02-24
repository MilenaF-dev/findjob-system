require "rails_helper"

feature "Visitor visit home page" do
  scenario "successfully" do
    visit root_path

    expect(page).to have_css("h1", text: "FindJob")
    expect(page).to have_css("h2", text: "Bem vindo ao sistema de ofertas de vagas")
  end
end

feature "Visitor search for vacancies and companies" do
  scenario "search for vacancies title" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, nivel: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :enabled)
    Vacancy.create!(title: "Techlead", description: "Vaga para atuar como líder técnico",
                    min_salary: 8000, max_salary: 12000, nivel: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 8 anos",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    fill_in "Pesquise por vagas e empresas", with: "Dev"
    click_on "Pesquisar"

    expect(current_path).to eq(search_path)
    expect(page).to have_link("Dev Júnior")
    expect(page).to have_content("Júnior")
    expect(page).to have_link("Dev Sênior")
    expect(page).to have_content("Sênior")
    expect(page).not_to have_link("Techlead")
  end

  scenario "search for vacancies nivel" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Vacancy.create!(title: "Dev Júnior", description: "Vaga de desenvolvidor júnior Ruby on Rails",
                    min_salary: 1500, max_salary: 3000, nivel: "Júnior",
                    mandatory_requirements: "Conhecimentos em Ruby, Rails, SQLite",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)
    Vacancy.create!(title: "Dev Sênior", description: "Vaga de desenvolvidor sênior Ruby on Rails",
                    min_salary: 8000, max_salary: 12000, nivel: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 5 anos",
                    deadline: "22/10/2021", total_vacancies: "2", company: company, status: :enabled)
    Vacancy.create!(title: "Techlead", description: "Vaga para atuar como líder técnico",
                    min_salary: 8000, max_salary: 12000, nivel: "Sênior",
                    mandatory_requirements: "Sólido conhecimentos em Ruby, Rails e SQLite, experiência de 8 anos",
                    deadline: "22/10/2021", total_vacancies: "3", company: company, status: :enabled)

    visit root_path
    fill_in "Pesquise por vagas e empresas", with: "Sênior"
    click_on "Pesquisar"

    expect(current_path).to eq(search_path)
    expect(page).to have_link("Techlead")
    expect(page).to have_content("Sênior")
    expect(page).to have_link("Dev Sênior")
    expect(page).not_to have_link("Dev Júnior")
    expect(page).not_to have_content("Júnior")
  end

  scenario "and search for companies name" do
    Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                    address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                    cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    Company.create!(name: "Americanas", description: "Varejo de diversos produtos",
                    address: "Rua Voluntários da Pátria, nº400, Centro, Campos dos Goytacazes-RJ",
                    cnpj: "789.546.333/000", site: "americanas.com.br", social_networks: "@americanas")

    visit root_path
    fill_in "Pesquise por vagas e empresas", with: "Algorich"
    click_on "Pesquisar"

    expect(current_path).to eq(search_path)
    expect(page).to have_link("Algorich")
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).not_to have_link("Americanas")
    expect(page).not_to have_content("Varejo de diversos produtos")
  end

  scenario "no results found" do
    Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                    address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                    cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    fill_in "Pesquise por vagas e empresas", with: "Americanas"
    click_on "Pesquisar"

    expect(current_path).to eq(search_path)
    expect(page).to have_content("Nenhum resultado encontrado")
  end

  scenario "and return to home page" do
    Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                    address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                    cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    fill_in "Pesquise por vagas e empresas", with: "Americanas"
    click_on "Pesquisar"
    click_on "Voltar"

    expect(current_path).to eq(root_path)
  end
end
