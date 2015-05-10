require 'rails_helper'

describe UsersController do
  let!(:user) { create :user }

  before { login_as user }

  describe "GET #show" do
    before { get :show, id: user.id }

    %w(id name surname nickname email city role correct_naming following_list followers_list last_sign_in_at_h).each do |attr|
      it "user contain #{attr}" do
        expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "render recipes as json" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #following" do
    let!(:following) { create :user }

    before do
      user.follow!(following)
      get :following, id: user.id
    end

    %w(id name surname nickname email city role last_sign_in_at_h correct_naming).each do |attr|
      it "following user contain #{attr}" do
        expect(response.body).to be_json_eql(following.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end

  end

  describe "GET #followers" do
    let!(:follower){ create :user }

    before do
      follower.follow!(user)
      get :followers, id: user.id
    end

    %w(id name surname nickname email city role last_sign_in_at_h correct_naming).each do |attr|
      it "follower user contain #{attr}" do
        expect(response.body).to be_json_eql(follower.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #recipes" do
    let!(:recipe) { create :recipe, user_id: user.id }

    before { get :recipes, id: user.id }

    %w(id title description image user_id rate comments_count steps_count).each do |attr|
      it "user's recipe contain #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #comments" do
    let!(:recipe) { create :recipe, user_id: user.id }
    let!(:comment) { create :comment, user_id: user.id, recipe_id: recipe.id }

    before { get :comments, id: user.id }

    %w(id text user_id recipe_id rate).each do |attr|
      it "user's comment contain #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #locale" do
    context "current locale - en" do
      before { post :locale, locale: "en" }

      it "revert locale to ru" do
        expect(session[:locale]).to eq("ru")
      end

      it "return 200 status" do
        expect(response.status).to eq(200)
      end
    end

    context "current locale - ru" do
      before { post :locale, locale: "ru" }

      it "revert locale to en" do
        expect(session[:locale]).to eq("en")
      end

      it "return 200 status" do
        expect(response.status).to eq(200)
      end
    end
  end

  describe "PUT #update" do
    context "with valida attributes" do
      it "update user data" do
        put :update, id: user.id, nickname: "awdaw"
        user.reload
        expect(user.nickname).to eq("awdaw")
      end

      it "return just updated user" do
        put :update, id: user.id, nickname: "awdaw"
        user.reload
        expect(response.body).to eq(user.to_json(methods: [:followers_list, :following_list, :correct_naming, :last_sign_in_at_h]))
      end
    end

    context "with invalida attributes" do
      it "doesn't update user data" do
        put :update, id: user.id, nickname: ""
        user.reload
        expect(user.nickname).to eq(user.nickname)
      end

      it "return users errors" do
        put :update, id: user.id, nickname: ""
        user.reload
        expect(JSON.parse(response.body)).to have_key("nickname")
      end
    end
  end
end