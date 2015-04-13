class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.is_admin? ? admin_abilities : current_user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def current_user_abilities
    guest_abilities
    can :create, Recipe
    can [:update, :destroy], Recipe, user_id: @user.id
    can [:read, :create, :destroy, :update, :recipe_ingridients], Ingridient
    can [:read, :create, :update, :destroy], Step
    can :create, Image
  end

  def admin_abilities
    can :manage, :all
  end
end
