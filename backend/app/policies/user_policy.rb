class UserPolicy < ApplicationPolicy
  def me?
    @user.has_role?(:admin) || @user.has_role?(:moderator) || @user.has_role?(:user)
  end

  def show?
    @user.has_role?(:admin) || @user.has_role?(:moderator) || @user.has_role?(:user) && @record.id == @user.id
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
