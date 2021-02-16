require "rails_helper"

feature "Admin edit a existent company" do
  scenario "have link" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    admin = User.create!(email: "milena@email.com", password: "123456", company: company, admin: true)

    login_as admin
    visit company_path(company)

    expect(page).to have_link("Editar",
                              href: edit_company_path(company))
  end

  scenario "button disappear if current user is not the admin" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    login_as user
    visit company_path(company)

    expect(page).not_to have_link("Editar",
                                  href: edit_company_path(company))
  end

  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    admin = User.create!(email: "milena@email.com", password: "123456", company: company, admin: true)

    login_as admin
    visit company_path(company)
    click_on "Editar"

    fill_in "Nome", with: "Algorich"
    fill_in "Descrição", with: "Empresa de desenvolvimento de softwares"
    fill_in "Endereço completo", with: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ"
    fill_in "CNPJ", with: "254.345.444./111"
    fill_in "Site", with: "algorich.com.br"
    fill_in "Redes sociais", with: "@algorich.tech"
    click_on "Atualizar Empresa"

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).to have_content("Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ")
    expect(page).to have_content("254.345.444./111")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("@algorich.tech")
    expect(page).to have_link("Voltar")
  end

  scenario "and company attributes cannot be blank" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    admin = User.create!(email: "milena@email.com", password: "123456", company: company, admin: true)

    login_as admin
    visit company_path(company)
    click_on "Editar"

    within("form") do
      fill_in "Nome", with: ""
      fill_in "Descrição", with: ""
      fill_in "Endereço completo", with: ""
      fill_in "CNPJ", with: ""
      fill_in "Site", with: ""
      fill_in "Redes sociais", with: ""
      click_on "Atualizar Empresa"
    end

    expect(page).to have_content("Não foi possível editar a empresa")
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Endereço completo não pode ficar em branco")
    expect(page).to have_content("CNPJ não pode ficar em branco")
    expect(page).to have_content("Site não pode ficar em branco")
  end

  scenario "and return to company page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
    admin = User.create!(email: "milena@email.com", password: "123456", company: company, admin: true)

    login_as admin
    visit root_path
    click_on "Empresas"
    click_on company.name
    visit company_path(company)
    click_on "Editar"
    click_on "Voltar"

    expect(current_path).to eq company_path(company)
  end

  # Passar testes de request para outro arquivo
  scenario "edit request protected if user is not admin", type: :request do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

    get edit_company_path(company)

    expect(response.status).to eq(404)
  end

  scenario "edit request protected if admin is from other company", type: :request do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    other_company = Company.create!(name: "Tech", description: "Empresa de desenvolvimento",
                                    address: "Campos dos Goytacazes-RJ",
                                    cnpj: "543.123.678/010", site: "tech.com.br", social_networks: "@tech.dev", domain: "dev.com")
    user = User.create!(email: "milena@dev.com", password: "123456", company: other_company, admin: true)

    get edit_company_path(company)

    expect(response.status).to eq(404)
  end
end

# feature "Admin delete a existent company" do
#   scenario "have link" do
#     company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
#                               address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
#                               cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
#     admin = User.create!(email: "milena@email.com", password: "123456", company: company, admin: true)

#     login_as admin
#     visit root_path
#     click_on "Empresas"
#     click_on company.name

#     expect(page).to have_selector("a[href='#{company_path(company)}'][data-method='delete']", text: "Apagar")
#   end

#   scenario "button disappear if current user is not the admin" do
#     company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
#                               address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
#                               cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
#     user = User.create!(email: "milena@email.com", password: "123456", company: company, admin: false)

#     login_as user
#     visit root_path
#     click_on "Empresas"
#     click_on company.name

#     expect(page).not_to have_selector("a[href='#{company_path(company)}'][data-method='delete']", text: "Apagar")
#   end

#   scenario "successfully" do
#     company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
#                               address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
#                               cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")
#     admin = User.create!(email: "milena@email.com", password: "123456", company: company, admin: true)

#     login_as admin
#     visit company_path(company)
#     click_on "Apagar"

#     expect(current_path).to eq(companies_path)
#     expect(page).to have_content("Empresa apagada com sucesso!")
#     expect(page).to_not have_content("Algorich")
#   end
# end
