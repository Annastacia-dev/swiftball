class RegistrationsController < Devise::RegistrationsController

  private

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  def account_update_params
    params.require(:user).permit(:username, :name, :country, :timezone)
  end
end