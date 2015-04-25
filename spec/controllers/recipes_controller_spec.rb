require 'rails_helper'

describe RecipesController do
  # login_user
  let!(:user) { create :user }
  let!(:recipes_first_page) { create_list :recipe, 12, user_id: user.id }
  let!(:recipes_second_page) { create_list :recipe, 12, user_id: user.id }
  let!(:recipe) { recipes_first_page[0] }
  let!(:image) { create :image, imageable_id: recipe.id, imageable_type: "Recipe" }

  describe "GET #index" do
    before { get :index }

    %w(id title user_id rate comments_count image).each do |attr|
      it "recipe attributes contain #{attr}" do
          expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "render recipes as json" do
      expect(response.status).to eq(200)
    end

    context "pagination" do
      let!(:json_params) { {only: [:title, :id, :user_id, :rate, :comments_count], methods: [:image]} }

      it "load first page" do
        get :index, page: 1
        expect(response.body).to eq(recipes_first_page.to_json(json_params))
      end

      it "load second page" do
        get :index, page: 2
        expect(response.body).to eq(recipes_second_page.to_json(json_params))
      end
    end
  end

  describe "GET #show" do
    it "return a recipe with id" do
      get :show, id: recipe.id, format: :json
      expect(response.body).to eq(recipe.to_json(methods: [:comments, :image, :steps, :tag_list]))
    end

    it "return 200 status" do
      get :show, id: recipe.id, format: :json
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