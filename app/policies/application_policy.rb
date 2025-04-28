# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.present?
  end

  def show?
    index?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
  attr_reader :user, :scope

  def initialize(user, scope)
    @user  = user
    @scope = scope
  end

  # Agora devolve todos os registros para usuários autorizados
  def resolve
    scope.all
  end
end

end
