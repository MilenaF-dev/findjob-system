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

feature "Candidate views his profile" do
  scenario "must be signed in" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    visit candidate_path(candidate)

    expect(page).to have_content("Precisa estar logado")
  end

  scenario "have link" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit root_path

    expect(page).to have_link("Meu perfil")
  end

  scenario "successfully" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Meu perfil"

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_content("Milena Ferreira")
    expect(page).to have_content("11111111")
    expect(page).to have_content("9999999")
    expect(page).to have_content("Tenho 25 anos, formada em Economia")
    expect(page).to have_link("Editar perfil")
  end
end

feature "Candidate edit profile" do
  scenario "must be signed in" do
    visit edit_candidate_registration_path

    expect(current_path).to eq new_candidate_session_path
  end

  scenario "successfully" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Meu perfil"
    click_on "Editar perfil"

    within("div.edit_form") do
      fill_in "Nome completo", with: "Milena das Neves Ferreira"
      fill_in "CPF", with: "123.456.354-39"
      fill_in "Telefone", with: "99999-8888"
      fill_in "Biografia resumida", with: "Tenho 25 anos, formada em Economia"
      fill_in "E-mail", with: "milena@mail.com"
      fill_in "Senha", with: "654321"
      fill_in "Confirme sua senha", with: "654321"
      fill_in "Senha atual", with: "123456"
      click_on "Atualizar"
    end

    expect(page).to have_content("milena@mail.com")
    expect(page).to have_content("A sua conta foi atualizada com sucesso")
  end

  scenario "attributes cannot be blank" do
    candidate = Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "milena@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Meu perfil"
    click_on "Editar perfil"

    within("div.edit_form") do
      fill_in "Nome completo", with: ""
      fill_in "CPF", with: ""
      fill_in "Telefone", with: ""
      fill_in "Biografia resumida", with: ""
      fill_in "E-mail", with: ""
      fill_in "Senha", with: ""
      fill_in "Confirme sua senha", with: ""
      fill_in "Senha atual", with: "123456"
      click_on "Atualizar"
    end

    expect(page).to have_content("Nome completo não pode ficar em branco")
    expect(page).to have_content("CPF não pode ficar em branco")
    expect(page).to have_content("Telefone não pode ficar em branco")
    expect(page).to have_content("E-mail não pode ficar em branco")
  end

  scenario "and cpf must be unique" do
    Candidate.create!(full_name: "Milena Ferreira", cpf: "11111111", phone: "9999999",
                      biography: "Tenho 25 anos, formada em Economia",
                      email: "milena@mail.com", password: "123456")
    candidate = Candidate.create!(full_name: "Carlos Ferreira", cpf: "84394789374", phone: "9999999",
                                  biography: "Tenho 25 anos, formada em Economia",
                                  email: "carlos@mail.com", password: "123456")

    login_as candidate, scope: :candidate
    visit root_path
    click_on "Meu perfil"
    click_on "Editar perfil"

    within("div.edit_form") do
      fill_in "CPF", with: "11111111"
      fill_in "E-mail", with: "milena@mail.com"
      fill_in "Senha atual", with: "123456"
      click_on "Atualizar"
    end

    expect(page).to have_content("E-mail já está em uso")
    expect(page).to have_content("CPF já está em uso")
  end
end
