# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(sign_up_params)

    if @user.valid?
      domain = @user.email.match(/(?<=@)[^.]+(?=\.).*/).to_s
      @user.company ||= Company.find_by(domain: domain)

      if @user.company.blank?
        @user.admin = true
        @user.company = Company.new
        flash[:notice] = t("misc.company_notice")
        render :new
      else
        unless @user.company.persisted?
          @user.admin = true
          @user.company.domain = domain
        end

        @user.save
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to company_path(@user.company)
      end
    else
      @user.admin = @user.company.present?
      render :new
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, company_attributes: [:name, :logo, :address, :description, :cnpj, :site, :social_networks])
  end
end
