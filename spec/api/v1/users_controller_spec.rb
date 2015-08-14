require 'rails_helper'

describe "API Users controller" do
  let!(:user) { create :user }
  let!(:access_token) { create :access_token, resource_owner_id: user.id }
  let!(:category) { create :category }
  let!(:recipes) { create_list :recipe, 12, user_id: user.id, category_id: category.id }
  let!(:recipe) { recipes.first }
  let!(:comments) { create_list :comment, 12, user_id: user.id, recipe_id: recipe.id }

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

  describe "POST #create" do
    context "with valid attributes" do
      it "create a new user" do
        expect{ post "/api/v1/users", user: attributes_for(:user) }.to change(User, :count).by(1)
      end

      it "return just create user" do
        post "/api/v1/users", user: attributes_for(:user)
        expect(response.body).to eq(User.last.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesnt' create an user" do
        expect{ post "/api/v1/users", user: attributes_for(:user, email: "") }.to change(User, :count).by(0)
      end

      it "return users errors" do
        post "/api/v1/users", user: attributes_for(:user, password: "")
        expect(JSON.parse(response.body)).to have_key("password")
      end
    end
  end


end