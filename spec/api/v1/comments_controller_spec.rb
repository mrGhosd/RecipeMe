require 'rails_helper'

describe "API Comments controller" do
  let!(:access_token) { create :access_token }
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:recipe) { create :recipe, user_id: user.id, category_id: category.id }

  let!(:comment) { create :comment, user_id: user.id, recipe_id: recipe.id }

  context "unauthorized" do
    let!(:api_path) { "/api/v1/recipes" }
    it_behaves_like "API Authenticable"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new comment" do
        expect{ post "/api/v1/recipes/#{recipe.id}/comments",
        recipe_id: recipe.id,
        comment: attributes_for(:comment, user_id: user.id, recipe_id: recipe.id),
        access_token: access_token.token, format: :json }.to change(Comment, :count).by(1)
      end

      it "return just created comment" do
        post "/api/v1/recipes/#{recipe.id}/comments",
        recipe_id: recipe.id,
        comment: attributes_for(:comment, user_id: user.id, recipe_id: recipe.id),
        access_token: access_token.token, format: :json
        expect(response.body).to eq(Comment.last.to_json)
      end
    end

    context "with invalid attributes" do
      it "creates a new comment" do
        expect{ post "/api/v1/recipes/#{recipe.id}/comments",
        recipe_id: recipe.id,
        comment: attributes_for(:comment, text: "", user_id: user.id, recipe_id: recipe.id),
        access_token: access_token.token, format: :json }.to change(Comment, :count).by(0)
      end

      it "return just created comment" do
        post "/api/v1/recipes/#{recipe.id}/comments",
             recipe_id: recipe.id,
             comment: attributes_for(:comment, text: "", user_id: user.id, recipe_id: recipe.id),
             access_token: access_token.token, format: :json
        expect(JSON.parse(response.body)).to have_key("text")
      end
    end
  end

end
