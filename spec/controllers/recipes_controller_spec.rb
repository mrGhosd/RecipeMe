require 'rails_helper'

describe RecipesController do
  let!(:recipe) { create :recipe }

  describe "GET #index" do
    it "return a list of recipes" do
      get :index
      expect(response.body).to eq(Recipe.all.to_json(methods: [:comments, :images]))
    end

    it "render recipes as json" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    it "return a recipe with id" do
      get :show, id: recipe.id
      expect(response.body).to eq(recipe.to_json(methods: [:comments, :images]))
    end

    it "return 200 status" do
      get :show, id: recipe.id
      expect(response.status).to eq(200)
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "update attributes of recipe" do
        put :update, id: recipe.id, title: "ololo", description: "awdawdawd"
        recipe.reload
        expect(recipe.title).to eq("ololo")
      end

      it "return 200 status" do
        put :update, id: recipe.id, title: "ololo", description: "awdawdawd"
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't update attributes of recipe" do
        put :update, id: recipe.id, title: "", description: "awdawdawd"
        recipe.reload
        expect(recipe.title).to eq(recipe.title)
      end

      it "return 200 status" do
        put :update, id: recipe.id, title: "", description: "awdawdawd"
        recipe.reload
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create a new recipe" do
        expect{post :create, {title: "ololo", description: "awdawdawd"}}.to change(Recipe, :count).by(1)
      end

      it "return status 200" do
        post :create, {title: "ololo", description: "awdawdawd"}
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new recipe" do
        expect{post :create, {title: "", description: "awdawdawd"}}.to change(Recipe, :count).by(0)
      end

      it "return new recipe errors" do
        post :create, title: "", description: "awdawdawd"
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end

  describe "DELETE #destroy" do
    it "delete selected recipe" do
      expect{delete :destroy,
      id: recipe.id}.to change(Recipe, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy,
      id: recipe.id
      expect(response.status).to eq(200)
    end
  end
end