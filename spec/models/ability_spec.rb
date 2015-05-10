require 'rails_helper'

describe Ability do

  subject(:ability) { Ability.new(user) }

  describe "for unsigned user" do
    let(:user) { nil }

    it { should be_able_to :locale, User }

    [Recipe, Category, Ingridient, Step, Callback, News, Comment].each do |model|
      it { should be_able_to :read, model }
    end

    it { should be_able_to :recipe_ingridients, Ingridient}
    it { should be_able_to :read, Callback }
    it { should be_able_to :create, Callback }
    it { should be_able_to :read, Category }
    it { should be_able_to :recipes, Category }
  end

  describe "for signed user" do
    let(:user) { create :user }
    let!(:diff_user) { create :user }

    let!(:diff_recipe) { create :recipe, user_id: diff_user.id }
    let!(:recipe) { create :recipe, user_id: user.id }

    let!(:callback) { create :callback, user_id: user.id }
    let!(:diff_callback) { create :callback, user_id: diff_user.id }

    let!(:comment) { create :comment, recipe_id: recipe.id, user_id: user.id }
    let!(:diff_comment) { create :comment, recipe_id: recipe.id, user_id: diff_user.id }

    it { should be_able_to :create, Recipe }

    it { should be_able_to :update, recipe }
    it { should_not be_able_to :update, diff_recipe}

    it { should be_able_to :destroy, recipe }
    it { should_not be_able_to :destroy, diff_recipe}

    it { should be_able_to :create, Step }
    it { should be_able_to :update, Step }
    it { should be_able_to :destroy, Step }

    it { should be_able_to :create, Ingridient }
    it { should be_able_to :update, Ingridient }
    it { should be_able_to :destroy, Ingridient }

    it { should be_able_to :create, Relationship }
    it { should be_able_to :index, Relationship }
    it { should be_able_to :destroy, Relationship }

    it { should be_able_to :rating, Recipe }
    it { should be_able_to :rating, Comment }
    it { should be_able_to :rating, News }

    it { should be_able_to :liked_users, Recipe }
    it { should be_able_to :liked_users, Comment }
    it { should be_able_to :liked_users, News }

    it { should be_able_to :create, Comment }

    it { should be_able_to :create, Image }

    it { should be_able_to :update, callback }
    it { should_not be_able_to :update, diff_callback }

    it { should be_able_to :update, comment }
    it { should_not be_able_to :update, diff_comment }

    it { should be_able_to :read, User }
    it { should be_able_to :following, User }
    it { should be_able_to :followers, User }
    it { should be_able_to :comments, User }
    it { should be_able_to :recipes, User }

    it { should be_able_to :update, user }
    it { should_not be_able_to :update, diff_user }

    it { should be_able_to :destroy, user }
    it { should_not be_able_to :destroy, diff_user }

    it { should be_able_to :read, Feed }


  end

  describe "for admin" do
    let(:user) { create :user, role: "admin" }

    it { should be_able_to :manage, :all }
  end

end
