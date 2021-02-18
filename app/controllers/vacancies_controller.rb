class VacanciesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :disable, :enable]

  def index
    @vacancies = Vacancy.all
  end

  def show
    set_vacancy
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = current_user.company.vacancies.new(vacancy_params)
    return head :not_found unless current_user&.company.present?

    if @vacancy.save
      redirect_to vacancy_path(@vacancy)
    else
      render :new
    end
  end

  def edit
    set_vacancy
    authorize_employee
  end

  def update
    set_vacancy
    authorize_employee

    if @vacancy.update(vacancy_params)
      redirect_to vacancy_path(@vacancy)
    else
      render :edit
    end
  end

  def disable
    set_vacancy
    authorize_employee

    @vacancy.disabled!

    redirect_to vacancy_path(@vacancy)
  end

  def enable
    set_vacancy
    authorize_employee

    @vacancy.enabled!

    redirect_to vacancy_path(@vacancy)
  end

  private

  def set_vacancy
    @vacancy = Vacancy.find(params[:id])
  end

  def vacancy_params
    params.require(:vacancy).permit(:title, :nivel, :description, :min_salary, :max_salary, :mandatory_requirements, :deadline, :total_vacancies, :company_id)
  end

  def authorize_employee
    return head :not_found unless current_user&.company == @vacancy.company
  end
end
