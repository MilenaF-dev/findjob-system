class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = [:full_name, :cpf, :phone, :biography, :email, :password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  protected

  def authenticate_user_or_candidate!
    return redirect_to root_path, notice: t("job_applications.messages.must_be_signed") unless user_signed_in? || candidate_signed_in?
  end
end
