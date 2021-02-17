class VacanciesController < ApplicationController
  def index
    @vacancies = Vacancy.all
  end

  def show
    @vacancy = Vacancy.find(params[:id])
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.new(vacancy_params)
    @vacancy.company = Company.last

    if @vacancy.save
      redirect_to vacancy_path(@vacancy)
    else
      render :new
    end
  end

  def edit
    @vacancy = Vacancy.find(params[:id])
  end

  def update
    @vacancy = Vacancy.find(params[:id])

    if @vacancy.update(vacancy_params)
      redirect_to vacancy_path(@vacancy)
    else
      render :edit
    end
  end

  private

  def vacancy_params
    params.require(:vacancy).permit(:title, :nivel, :description, :min_salary, :max_salary, :mandatory_requirements, :deadline, :total_vacancies, :company_id)
  end
end
