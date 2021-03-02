class HomeController < ApplicationController
  def index
  end

  def search
    @companies = Company.with_name(params[:search])
    @vacancies = Vacancy.with_title_or_level(params[:search])
  end
end
