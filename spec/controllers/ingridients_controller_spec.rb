require 'rails_helper'

describe IngridientsController do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }
  let!(:ingridient) { create :ingridient }
  let!(:ingridient) { create :ingridient }

  describe "GET #index" do
    before { get :index }
    %w(id name).each do |attr|
      it "ingridient contain #{attr}" do
        expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

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
