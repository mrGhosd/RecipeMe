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
    before { get :show, recipe_id: recipe.id, id: ingridient.id }

    %w(id name).each do |attr|
      it "ingridient contain #{attr}" do
        expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end

  end

  describe "POST #create" do
    before do
      login_as user
    end

    context "ingridient exisits and present in recipe ingridients list" do
      before do
        recipe.recipe_ingridients.create ingridient: ingridient, size: 20
      end

      it "return ingridient " do
        post :create, recipe_id: recipe.id, name: ingridient.name, in_size: 20
        expect(response.body).to eq(ingridient.to_json)
      end
    end

    context "ingridient exists, but doesn't present in recipes ingridients" do
      it "create ingridient" do
        expect{ post :create, recipe_id: recipe.id, name: ingridient.name, in_size: 20 }.to change(Ingridient, :count).by(0)
      end

      it "add just created ingridient to recipe ingridients" do
        expect{ post :create, recipe_id: recipe.id, name: ingridient.name, in_size: 20 }.to change(recipe.recipe_ingridients, :count).by(1)
      end

      it "return 200 status" do
        post :create, recipe_id: recipe.id, name: "ooooo", in_size: 20
        expect(response.status).to eq(200)
      end
    end

    context "ingridient doesn't exists" do
      it "create ingridient" do
        expect{ post :create, recipe_id: recipe.id, name: "ooooo", in_size: 20 }.to change(Ingridient, :count).by(1)
      end

      it "add just created ingridient to recipe ingridients" do
        expect{ post :create, recipe_id: recipe.id, name: "ooooo", in_size: 20 }.to change(recipe.recipe_ingridients, :count).by(1)
      end

      it "return 200 status" do
        post :create, recipe_id: recipe.id, name: "ooooo", in_size: 20
        expect(response.status).to eq(200)
      end
    end
  end

  describe "PUT #update" do

    before do
      login_as user
      recipe.recipe_ingridients.create ingridient: ingridient, size: 20
      put :update, recipe_id: recipe.id, id: ingridient.id, name: "OloloevOlololosh"
      ingridient.reload
    end

    it "update the ingridient value" do
      expect(ingridient.name).to eq("OloloevOlololosh")
    end

    %w(id name).each do |attr|
      it "ingridient contain #{attr}" do
        expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("#{attr}")
      end
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
