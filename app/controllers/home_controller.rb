class HomeController < ApplicationController
  def index
  end

  def search
    @vacancies = Vacancy.where("title like ? OR level like ?",
                               "%#{params[:search]}%", "%#{params[:search]}%")

    @companies = Company.where("name like ?", "%#{params[:search]}%")
  end
end
