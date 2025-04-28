# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit

  # Devise: exige login
  before_action :authenticate_user!
  # Força troca de senha no primeiro acesso
  before_action :require_password_change

  # Pundit: lida com autorização
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  # Depois do login, se ainda for first_access, vai para a edição de senha
  def after_sign_in_path_for(resource)
    authenticated_root_path
  end

  private

  # Se usuário logado e first_access, redireciona para editar perfil
  def require_password_change
    return unless user_signed_in? && current_user.first_access?

    # Permitir só access às actions de editar/atualizar registro do Devise
    if devise_controller? && controller_name == 'registrations' && action_name.in?(%w[edit update])
      return
    end

    redirect_to edit_user_registration_path,
      alert: 'Você precisa alterar sua senha provisória antes de continuar.'
  end

  # Pundit: quando não autorizado
  def user_not_authorized
    flash[:alert] = "Você não tem permissão para fazer isso."
    redirect_to(request.referrer || root_path)
  end
end

