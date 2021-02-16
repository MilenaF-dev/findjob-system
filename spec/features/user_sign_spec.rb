require "rails_helper"

feature "User sign up without a company" do
  scenario "need to register company" do
    visit root_path
    click_on "Registrar-se"

    within("form") do
      fill_in "E-mail", with: "milena@email.com"
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      click_on "Registrar-se"
    end

    expect(page).to have_content("Nenhuma empresa cadastrada com esse domínio. Para continuar, cadastre sua empresa!")
  end

  scenario "successfully" do
    visit root_path
    click_on "Registrar-se"

    within("form") do
      fill_in "E-mail", with: "milena@email.com"
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      click_on "Registrar-se"
    end

    within("form") do
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      fill_in "Nome", with: "Algorich"
      fill_in "Descrição", with: "Empresa de desenvolvimento de softwares"
      fill_in "Endereço completo", with: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ"
      fill_in "CNPJ", with: "123.234.333/000"
      fill_in "Site", with: "algorich.com.br"
      fill_in "Redes sociais", with: "@algorich"
      click_on "Registrar-se"
    end

    expect(page).to have_content("milena@email.com")
    expect(page).to have_content("Bem vindo! Você realizou seu registro com sucesso")
    expect(User.last.admin).to eq(true)
    expect(User.last.company.domain).to eq("email.com")
    expect(page).to have_link("Sair")
    expect(page).not_to have_link("Entrar")
  end
end

feature "User sign up for an existent company" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")

    visit root_path
    click_on "Registrar-se"

    within("form") do
      fill_in "E-mail", with: "milena@email.com"
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      click_on "Registrar-se"
    end

    expect(page).to have_content("milena@email.com")
    expect(page).to have_content("Bem vindo! Você realizou seu registro com sucesso")
    expect(User.last.admin).to eq(false)
  end

  scenario "and attributes cannot be blank" do
    visit root_path
    click_on "Registrar-se"
    within("form") do
      fill_in "E-mail", with: ""
      fill_in "Senha", with: ""
      fill_in "Confirme sua senha", with: ""
      click_on "Registrar"
    end

    expect(page).to have_content("E-mail não pode ficar em branco")
    expect(page).to have_content("Senha não pode ficar em branco")
  end
end

feature "User sign in" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company)

    visit root_path
    click_on "Entrar"
    within("form") do
      fill_in "E-mail", with: user.email
      fill_in "Senha", with: "123456"
      click_on "Entrar"
    end

    expect(page).to have_content(user.email)
    expect(page).to have_content("Login efetuado com sucesso")
    expect(page).to have_link("Sair")
    expect(page).not_to have_link("Entrar")
    expect(page).not_to have_link("Registrar-se")
  end

  scenario "and logout" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company)

    visit root_path
    click_on "Entrar"
    within("form") do
      fill_in "E-mail", with: user.email
      fill_in "Senha", with: "123456"
      click_on "Entrar"
    end

    click_on "Sair"

    within("nav") do
      expect(page).not_to have_link("Sair")
      expect(page).not_to have_content(user.email)
      expect(page).to have_link("Entrar")
      expect(page).to have_link("Registrar-se")
    end
  end
end
