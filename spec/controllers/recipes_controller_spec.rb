require 'rails_helper'

describe RecipesController do
  let!(:user) { create :user }
  let!(:recipes_first_page) { create_list :recipe, 12, user_id: user.id }
  let!(:recipes_second_page) { create_list :recipe, 12, user_id: user.id }
  let!(:recipe) { recipes_first_page[0] }

  let!(:image) { create :image, imageable_id: recipe.id, imageable_type: "Recipe" }

  before { login_as user }


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
    let!(:step){ create :step, recipe_id: recipe.id }
    let!(:comment) { create :comment, recipe_id: recipe.id, user_id: user.id }
    let!(:ingridient) { create :ingridient }
    let!(:recipe_ingridient) { create :recipe_ingridient, recipe_id: recipe.id, ingridient_id: ingridient.id }

    before { get :show, id: recipe.id, format: :json }

    %w(id title description tag_list user_id rate image comments steps ingridients user created_at_h).each do |attr|
      it "recipe attributes contain #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    context "comments" do

      it "included comments" do
        expect(response.body).to have_json_size(1).at_path("comments")
      end

      %w(id user_id recipe_id text created_at updated_at rate).each do |attr|
        it "recipe comment contain #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end
    end

    context "ingridients" do

      it "included ingridients" do
        expect(response.body).to have_json_size(1).at_path("ingridients")
      end

      %w(id name created_at updated_at).each do |attr|
        it "recipe ingridient contain #{attr}" do
          expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("ingridients/0/#{attr}")
        end
      end
    end

    context "steps" do


      it "included steps" do
        expect(response.body).to have_json_size(1).at_path("steps")
      end

      %w(id recipe_id description created_at updated_at).each do |attr|
        it "recipe step contain #{attr}" do
          expect(response.body).to be_json_eql(step.send(attr.to_sym).to_json).at_path("steps/0/#{attr}")
        end
      end

    end

    context "image" do
      it "included image" do
        expect(response.body).to have_json_size(6).at_path("image")
      end

      %w(id imageable_type imageable_id created_at updated_at).each do |attr|
        it "recipe image contain #{attr}" do
          expect(response.body).to be_json_eql(image.send(attr.to_sym).to_json).at_path("image/#{attr}")
        end
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "update attributes of recipe" do
        patch :update, id: recipe.id, title: "ololo", description: "awdawdawd", user_id: user.id
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
        expect{post :create, {title: "ololo", description: "awdawdawd", user_id: user.id}}.to change(Recipe, :count).by(1)
      end

      it "return status 200" do
        post :create, {title: "ololo", description: "awdawdawd", user_id: user.id}
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new recipe" do
        expect{post :create, {title: "", description: "awdawdawd", user_id: user.id}}.to change(Recipe, :count).by(0)
      end

      it "return new recipe errors" do
        post :create, title: "", description: "awdawdawd", user_id: user.id
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