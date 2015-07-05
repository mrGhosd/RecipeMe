require 'rails_helper'

describe "API Users controller" do
  let!(:user) { create :user }
  let!(:access_token) { create :access_token, resource_owner_id: user.id }
  let!(:category) { create :category }
  let!(:recipes) { create_list :recipe, 12, user_id: user.id, category_id: category.id }
  let!(:recipe) { recipes.first }
  let!(:comments) { create_list :comment, 12, user_id: user.id, recipe_id: recipe.id }

  context "unauthorized" do
    let!(:api_path) { "/api/v1/users" }
    it_behaves_like "API Authenticable"
  end

  describe "GET #profile" do
    before {get "/api/v1/users/profile", access_token: access_token.token, format: :json}

    %w(id email surname name nickname date_of_birth city).each do |attr|
      it "current user profile contains #{attr}" do
        expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "return status 200" do
      expect(response.status).to eq(200)
    end
  end


end