require "rails_helper"

feature "Candidate sign up" do
  scenario "successfully" do
    visit root_path
    click_on "Registrar-se"

    within("form") do
      fill_in "Nome completo", with: "Milena das Neves Ferreira"
      fill_in "CPF", with: "123.456.354-39"
      fill_in "Telefone", with: "99999-8888"
      fill_in "Biografia resumida", with: "Tenho 25 anos, formada em Economia"
      fill_in "E-mail", with: "milena@mail.com"
      fill_in "Senha", with: "123456"
      fill_in "Confirme sua senha", with: "123456"
      click_on "Registrar-se"
    end

    expect(page).to have_content("milena@mail.com")
    expect(page).to have_content("Bem vindo! Você realizou seu registro com sucesso")
  end

  scenario "attributes cannot be blank" do
    visit root_path
    click_on "Registrar-se"

    within("form") do
      fill_in "Nome completo", with: ""
      fill_in "CPF", with: ""
      fill_in "Telefone", with: ""
      fill_in "Biografia resumida", with: ""
      fill_in "E-mail", with: ""
      fill_in "Senha", with: ""
      fill_in "Confirme sua senha", with: ""
      click_on "Registrar"
    end

    expect(page).to have_content("Nome completo não pode ficar em branco")
    expect(page).to have_content("CPF não pode ficar em branco")
    expect(page).to have_content("Telefone não pode ficar em branco")
    expect(page).to have_content("E-mail não pode ficar em branco")
    expect(page).to have_content("Senha não pode ficar em branco")
  end

  scenario "and cpf must be unique" do
    Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                      biography: "Tenho 25 anos, formada em Economia",
                      email: "milena@mail.com", password: "123456")

    visit root_path
    click_on "Registrar-se"

    within("form") do
      fill_in "CPF", with: "11111111"
      click_on "Registrar"
    end

    expect(page).to have_content("CPF já está em uso")
  end
end

feature "Candidate sign in" do
  scenario "successfully" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    visit root_path
    click_on "Entrar"

    within("form") do
      fill_in "E-mail", with: candidate.email
      fill_in "Senha", with: "123456"
      click_on "Entrar"
    end

    expect(page).to have_content(candidate.email)
    expect(page).to have_content("Login efetuado com sucesso")
    expect(page).to have_link("Sair")
    expect(page).not_to have_link("Entrar")
    expect(page).not_to have_link("Registrar-se")
  end

  scenario "and logout" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    visit root_path
    click_on "Entrar"

    within("form") do
      fill_in "E-mail", with: candidate.email
      fill_in "Senha", with: "123456"
      click_on "Entrar"
    end

    click_on "Sair"

    within("nav") do
      expect(page).not_to have_link("Sair")
      expect(page).not_to have_content(candidate.email)
      expect(page).to have_link("Entrar")
      expect(page).to have_link("Registrar-se")
      expect(page).to have_link("Acesso empresa")
    end
  end
end
