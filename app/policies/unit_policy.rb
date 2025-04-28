class UnitPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end

class UnitPolicy < ApplicationPolicy
  class Scope < Scope                  # herda de ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end

