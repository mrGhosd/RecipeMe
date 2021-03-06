require 'rails_helper'

describe CategoriesController do
  let!(:admin) { create :user, role: "admin" }
  let!(:user) { create :user, email: "ololos@mail.ru" }
  let!(:category) { create :category }
  let!(:recipe) { create :recipe, category_id: category.id, user_id: user.id }

  before { login_as admin }

  describe "GET #index" do
    before { get :index }

    %w(id title created_at).each do |attr|
      it "category contain #{attr}" do
        expect(response.body).to be_json_eql(category.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return an list of categories" do
      expect(response.body).to eq([category].to_json(only: [:id, :title, :created_at]))
    end

    it "return status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    before { get :show, id: category.id }

    it "return an particular category" do
      expect(response.body).to eq(category.to_json(methods: [:image, :recipes]))
    end

    it "return status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #recipes" do
    let!(:recipe_first_list) { create_list :recipe, 8, user_id: user.id, category_id: category.id }
    let!(:recipe_second_list) { create_list :recipe, 8, user_id: user.id, category_id: category.id }
    let!(:recipe_item) { recipe_second_list.last }

    before { get :recipes, id: category.id }

    %w(id title user_id image).each do |attr|
      it "category recipe contain #{attr}" do
        expect(response.body).to be_json_eql(recipe_item.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end


  end

  describe "POST #create" do
    it "create a new category" do
      expect{ post :create, category: {title: "1", description: "2"} }.to change(Category, :count).by(1)
    end

    it "return this category" do
      post :create, category: attributes_for(:category)
      expect(response.body).to eq Category.last.to_json
    end
  end

  describe "PUT #update" do

    it "define a particular category" do
      put :update, id: category.id, category: attributes_for(:category)
      expect(assigns(:category)).to eq category
    end

    it "update category attributes" do
      put :update, id: category.id, category: attributes_for(:category, title: "category")
      category.reload
      expect(category.title).to eq("category")
    end

    it "return success json" do
      put :update, id: category.id, category: attributes_for(:category, title: "category")
      expect(response.body).to eq({success: true}.to_json)
    end
  end

  describe "DELETE #destroy" do
    it "delete particular category" do
      expect{ delete :destroy, id: category.id }.to change(Category, :count).by(-1)
    end

    it "return success status" do
      delete :destroy, id: category.id
      expect(response.status).to eq(200)
    end
  end

  describe "GET #recipes" do
    before { get :recipes, id: category.id }
    it "return all recipes, that belongs to particular category" do
      expect(response.body).to eq(category.recipes.to_json(only: [:title, :id, :user_id], methods: [:image]))
    end

    it "return succes true status" do
      expect(response.status).to eq(200)
    end
  end
end