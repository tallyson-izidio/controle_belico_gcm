# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # Pula o filtro que impede usuários logados de acessar new/create
  skip_before_action :require_no_authentication, only: %i[new create]

  # Só admin pode acessar new/create
  before_action :authorize_admin, only: %i[new create]

  # Após update (troca de senha), zera first_access
  def update
    super do |user|
      if user.first_access?
        user.update_column(:first_access, false)
      end
    end
  end

  private

  def authorize_admin
    unless current_user&.admin?
      flash[:alert] = "Somente admins podem cadastrar novos usuários."
      redirect_to authenticated_root_path
    end
  end

  # Define quais parâmetros são permitidos no sign_up (nova conta)
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Define quais parâmetros são permitidos na atualização de conta
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
