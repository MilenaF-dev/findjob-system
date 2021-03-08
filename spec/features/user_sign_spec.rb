require "rails_helper"

feature "User sign up without a company" do
  scenario "need to register company" do
    visit root_path
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end

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
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end

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
      attach_file "Logomarca", Rails.root.join("spec", "support", "logo_algorich.png")
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
    expect(current_path).to eq(company_path(Company.last))
    expect(page).to have_content("Algorich")
    expect(page).to have_css('img[src*="logo_algorich.png"]')
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).to have_content("Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ")
    expect(page).to have_content("123.234.333/000")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("@algorich")
  end

  scenario "and company attributes cannot be blank" do
    visit root_path
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end
    within("form") do
      fill_in "E-mail", with: "milena@email.com"
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      click_on "Registrar-se"
    end

    within("form") do
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      fill_in "Nome", with: ""
      # attach_file "Logomarca", Rails.root()
      fill_in "Descrição", with: ""
      fill_in "Endereço completo", with: ""
      fill_in "CNPJ", with: ""
      fill_in "Site", with: ""
      fill_in "Redes sociais", with: ""
      click_on "Registrar-se"
    end

    expect(Company.count).to eq 0
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Endereço completo não pode ficar em branco")
    expect(page).to have_content("CNPJ não pode ficar em branco")
    expect(page).to have_content("Site não pode ficar em branco")
  end

  scenario "and name and cnpj must be unique" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich")

    visit root_path
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end

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
      fill_in "CNPJ", with: "123.234.333/000"
      click_on "Registrar-se"
    end

    expect(page).to have_content("Nome já está em uso")
    expect(page).to have_content("CNPJ já está em uso")
  end

  scenario "if company attributes cannot be blank renders the form again" do
    visit root_path
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end
    within("form") do
      fill_in "E-mail", with: "milena@email.com"
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      click_on "Registrar-se"
    end

    within("form") do
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      fill_in "Nome", with: ""
      fill_in "Descrição", with: ""
      fill_in "Endereço completo", with: ""
      fill_in "CNPJ", with: ""
      fill_in "Site", with: ""
      fill_in "Redes sociais", with: ""
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
    expect(current_path).to eq(company_path(Company.last))
    expect(page).to have_content("Algorich")
    expect(page).to have_content("Empresa de desenvolvimento de softwares")
    expect(page).to have_content("Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ")
    expect(page).to have_content("123.234.333/000")
    expect(page).to have_content("algorich.com.br")
    expect(page).to have_content("@algorich")
  end
end

feature "User sign up for an existent company" do
  scenario "successfully" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich", domain: "email.com")

    visit root_path
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end

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
    click_on "Acesso empresa"
    within("div.links") do
      click_on "Registrar-se"
    end

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
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich",
                              domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company)

    visit root_path
    click_on "Acesso empresa"

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
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich",
                              domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company)

    visit root_path
    click_on "Acesso empresa"

    within("form") do
      fill_in "E-mail", with: user.email
      fill_in "Senha", with: "123456"
      click_on "Entrar"
    end

    click_on "Sair"

    within("nav") do
      expect(page).not_to have_link("Sair")
      expect(page).not_to have_content(user.email)
      expect(page).to have_link("Acesso empresa")
      expect(page).to have_link("Entrar")
      expect(page).to have_link("Registrar-se")
    end
  end
end

feature "User signed in visits company page" do
  scenario "visit company page" do
    company = Company.create!(name: "Algorich", description: "Empresa de desenvolvimento de softwares",
                              address: "Praça II, nº10, Flamboyant, Campos dos Goytacazes-RJ",
                              cnpj: "123.234.333/000", site: "algorich.com.br", social_networks: "@algorich",
                              domain: "email.com")
    user = User.create!(email: "milena@email.com", password: "123456", company: company)

    login_as user, scope: :user
    visit root_path
    click_on "Área da empresa"

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content(user.email)
  end
end
