class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    set_company
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to company_path(@company)
    else
      render :new
    end
  end

  def edit
    set_company
  end

  def update
    set_company

    if @company.update(company_params)
      redirect_to company_path(@company)
    else
      render :edit
    end
  end

  def destroy
    set_company
    @company.destroy

    flash[:notice] = "Empresa apagada com sucesso!"
    redirect_to companies_path
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :description, :address, :cnpj, :site, :social_networks, :logo)
  end
end
