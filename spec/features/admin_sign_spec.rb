require "rails_helper"

feature "Admin sign in" do
  scenario "sign up" do
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
    expect(page).to have_link("Sair")
    expect(page).not_to have_link("Entrar")
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

  scenario "successfully" do
    user = User.create!(email: "milena@email.com", password: "123456")

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
    user = User.create!(email: "milena@email.com", password: "123456")

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
