require 'rails_helper'

describe CommentsController do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }
  let!(:comment_first_page) { create_list :comment, 5, user_id: user.id, recipe_id: recipe.id }
  let!(:comment_second_page) { create_list :comment, 5, user_id: user.id, recipe_id: recipe.id }
  let!(:comment) { comment_second_page.last }

  before { login_as user }

  describe "GET #index" do
    before { get :index, recipe_id: recipe.id }

    %w(id user_id recipe_id text rate).each do |attr|
      it "comment contain #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    before { get :show, recipe_id: recipe.id, id: comment.id }

    %w(id user_id recipe_id text rate ).each do |attr|
      it "comment contain #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create a new comment for recipe" do
        expect{post :create,
        recipe_id: recipe.id,
        comment: attributes_for(:comment, user_id: user.id, recipe_id: recipe.id)}.to change(Comment, :count).by(1)
      end

      it "return just created comment" do
        post :create,
        recipe_id: recipe.id,
        comment: attributes_for(:comment, user_id: user.id, recipe_id: recipe.id)
        expect(response.body).to eq(Comment.last.to_json)
      end
    end

    context "with invalid attributes" do
      it "create a new comment for recipe" do
        expect{post :create,
        recipe_id: recipe.id,
        comment: attributes_for(:comment, text: "", user_id: user.id, recipe_id: recipe.id)}.to change(Comment, :count).by(0)
      end

      it "return comment errors" do
        post :create,
        recipe_id: recipe.id,
        comment: attributes_for(:comment, text: "", user_id: user.id, recipe_id: recipe.id)
        expect(JSON.parse(response.body)).to have_key("text")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "update attributes of comment" do
        put :update,
        recipe_id: recipe.id,
        id: comment.id,
        comment: attributes_for(:comment, text: "Ololo")
        comment.reload
        expect(comment.text).to eq("Ololo")
      end

      it "return an updated comment" do
        put :update,
        recipe_id: recipe.id,
        id: comment.id,
        comment: attributes_for(:comment)
        expect(response.body).to eq(comment.to_json)
      end
    end

    context "with invalid attributes" do
      it "update attributes of comment" do
        put :update,
        recipe_id: recipe.id,
        id: comment.id,
        comment: attributes_for(:comment, text: "")
        comment.reload
        expect(comment.text).to eq(comment.text)
      end

      it "return an updated comment" do
        put :update,
        recipe_id: recipe.id,
        id: comment.id,
        comment: attributes_for(:comment, text: "")
        expect(JSON.parse(response.body)).to have_key("text")
      end
    end
  end

  describe "DELETE #destroy" do
    it "delete expected comment" do
      expect { delete :destroy,
      recipe_id: recipe.id,
      id: comment.id}.to change(Comment, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy,
      recipe_id: recipe.id,
      id: comment.id
      expect(response.status).to eq(200)
    end
  end
end