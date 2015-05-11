require 'rails_helper'

describe RecipeIngridient do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }

  it { should belong_to :recipe }
  it { should belong_to :ingridient }

  describe ".increment_counter" do
    let!(:ingridient) { create :ingridient }
    it "increment recipe ingridients count" do
      create :recipe_ingridient, ingridient: ingridient, recipe: recipe
      expect(recipe.recipe_ingridients_count).to eq(recipe.ingridients.count)
    end
  end

  describe ".decrement counter" do
    let!(:ingridient) { create :ingridient }
    it "decrement recipe ingridients count" do
      recipe_ingridient = create :recipe_ingridient, ingridient: ingridient, recipe: recipe
      recipe_ingridient.destroy
      recipe.reload
      expect(recipe.recipe_ingridients_count).to eq(0)
    end
  end
end