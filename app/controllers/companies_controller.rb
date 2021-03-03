class CompaniesController < ApplicationController
  def index
    @companies = Company.all
    @companies = @companies.with_name(params[:search])
  end

  def show
    set_company
  end

  def edit
    set_company
    authorize_admin
  end

  def update
    set_company
    authorize_admin

    if @company.update(company_params)
      redirect_to company_path(@company)
    else
      render :edit
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :description, :address, :cnpj, :site, :social_networks, :logo)
  end

  def authorize_admin
    return head :not_found unless current_user&.admin? && current_user.company == @company
  end
end
