class Users::RegistrationsController < Devise::RegistrationsController
  # Pula o filtro que impede usuários logados de acessar new/create
  skip_before_action :require_no_authentication, only: %i[new create]

  # Só admin pode acessar new/create
  before_action :authorize_admin, only: %i[new create]

  # Verifique se é o primeiro acesso
  before_action :check_first_access, only: [:edit, :update]

  # Após update (troca de senha), zera first_access
  def update
    super do |user|
      if user.first_access?
        user.update_column(:first_access, false)  # Atualiza o first_access para false após o primeiro login
      end
    end
  end

  # Após cadastro, redireciona dependendo do first_access
  def after_sign_up_path_for(resource)
    if resource.first_access?
      edit_user_registration_path  # Redireciona para a página de edição se for o primeiro acesso
    else
      authenticated_root_path  # Caso contrário, redireciona para a página inicial do usuário
    end
  end

  private

  def authorize_admin
    unless current_user&.admin?
      flash[:alert] = "Somente admins podem cadastrar novos usuários."
      redirect_to authenticated_root_path
    end
  end

  # Verifica se é o primeiro acesso, permitindo a edição apenas no primeiro login
  def check_first_access
    if !current_user.first_access?
      redirect_to root_path, alert: "Você não pode editar sua conta agora."
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
