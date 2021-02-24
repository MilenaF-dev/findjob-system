class HomeController < ApplicationController
  def index
  end

  def search
    @vacancies = Vacancy.where("title like ? OR nivel like ?",
                               "%#{params[:search]}%", "%#{params[:search]}%")

    @companies = Company.where("name like ?", "%#{params[:search]}%")
  end
end
