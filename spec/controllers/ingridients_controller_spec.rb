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

  describe "GET #recipe_ingridients" do

    before do
      recipe.recipe_ingridients.create ingridient: ingridient, size: 20
      recipe_ing = recipe.recipe_ingridients.last
      @recipe_ingridient = ingridient.attributes.merge({'size'  => recipe_ing.size.to_s, 'recipe' => recipe_ing.recipe_id.to_i })
      get :recipe_ingridients, recipe_id: recipe.id
    end

    %w(id name size recipe).each do |attr|
      it "recipe ingridient contain #{attr}" do
        expect(response.body).to be_json_eql(@recipe_ingridient[attr].to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do

  end

  describe "POST #create" do
    context "ingridient exisits and present in recipe ingridients list" do

    end

    context "ingridient exists, but doesn't present in recipes ingridients" do

    end

    context "ingridient doesn't exists" do

    end
  end

  describe "PUT #update" do

  end

  describe "DELETE #destroy" do

  end
end
