require 'rails_helper'

describe "API Recipes controller" do
  let!(:access_token) { create :access_token }
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:recipes) { create_list :recipe, 12, user_id: user.id, category_id: category.id }
  let!(:recipe) { recipes.first }

  let!(:step) { create :step, recipe_id: recipe.id }
  let!(:image) { create :image, imageable_id: step.id, imageable_type: "Step"}

  let!(:ingridient) { create :ingridient }
  let!(:recipe_ingridient) { create :recipe_ingridient, recipe_id: recipe.id, ingridient_id: ingridient.id }

  context "unauthorized" do
    let!(:api_path) { "/api/v1/recipes" }
    it_behaves_like "API Authenticable"
  end


  describe "GET #index" do
    before { get "/api/v1/recipes", access_token: access_token.token, format: :json }

    %w(id title description rate user image persons difficult time).each do |attr|
      it "recipe in recipes list contains #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    before { get "/api/v1/recipes/#{recipe.id}", access_token: access_token.token, format: :json }

    %w(id title description rate user image persons difficult time steps_list ingridients_list comments_list).each do |attr|
      it "recipe contains #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    context "steps" do
      before do
        step.update(image: image)
      end

      %w(id recipe_id description image).each do |attr|
        it "recipe step contains #{attr}" do
          expect(response.body).to be_json_eql(step.send(attr.to_sym).to_json).at_path("steps_list/0/#{attr}")
        end
      end
    end

    context "ingridients" do
      %w(id name created_at updated_at).each do |attr|
        it "recipe ingridient contains #{attr}" do
          expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("ingridients_list/0/#{attr}")
        end
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new recipe" do
        expect {
          post "/api/v1/recipes", access_token: access_token.token,
               format: :json, recipe: attributes_for(:recipe, category_id: category.id, user_id: user.id)
        }.to change(Recipe, :count).by(1)
      end

      it "return just created recipe" do
        post "/api/v1/recipes", access_token: access_token.token,
             format: :json, recipe: attributes_for(:recipe, category_id: category.id, user_id: user.id)
        expect(response.body).to eq(Recipe.last.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new recipe" do
        expect {
          post "/api/v1/recipes", access_token: access_token.token,
               format: :json, recipe: attributes_for(:recipe, title: "", category_id: category.id, user_id: user.id)
        }.to change(Recipe, :count).by(0)
      end

      it "return errors array" do
        post "/api/v1/recipes", access_token: access_token.token,
             format: :json, recipe: attributes_for(:recipe, title: "", category_id: category.id, user_id: user.id)
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end
end