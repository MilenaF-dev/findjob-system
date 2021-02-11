require "rails_helper"

feature "Visitor visit home page" do
  scenario "successfully" do
    visit root_path

    expect(page).to have_css("h1", text: "FindJob System")
    expect(page).to have_css("h2", text: "Bem vindo ao sistema de ofertas de vagas")
  end
end
