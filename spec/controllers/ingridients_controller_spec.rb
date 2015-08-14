require 'rails_helper'

describe IngridientsController do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }
  let!(:ingridient) { create :ingridient }
  let!(:ingridient) { create :ingridient }

  describe "DELETE #destroy" do
    before do
      recipe.recipe_ingridients.create ingridient: ingridient, size: 20
      login_as user
    end

    it "destroy ingridient" do
      expect{ delete :destroy, recipe_id: recipe.id, id: ingridient.id }.to change(recipe.ingridients, :count).by(-1)
    end

    it "delete ingridient from recipes list" do
      expect{ delete :destroy, recipe_id: recipe.id, id: ingridient.id }.to change(recipe.recipe_ingridients, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy, recipe_id: recipe.id, id: ingridient.id
      expect(response.status).to eq(200)
    end
  end
end
