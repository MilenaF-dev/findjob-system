class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(sign_up_params)

    if @user.valid?
      domain = @user.email.match(/(?<=@)[^.]+(?=\.).*/).to_s
      @user.company ||= Company.find_by(domain: domain)

      if @user.company.blank?
        @user.admin = true
        @user.company = Company.new
        flash[:notice] = "Nenhuma empresa cadastrada com esse domínio. Para continuar, cadastre sua empresa!"
        render :new
      else
        unless @user.company.persisted?
          @user.admin = true
          @user.company.domain = domain
        end

        @user.save
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to root_path
      end
    else
      render :new
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, company_attributes: [:name, :address, :description, :cnpj, :site, :social_networks])
  end
end
