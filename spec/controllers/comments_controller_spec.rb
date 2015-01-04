require 'rails_helper'

describe CommentsController do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe }
  let!(:comment) { create :comment, user_id: user.id, recipe_id: recipe.id }

  describe "GET #index" do
    it "return a collection of comments for recipe" do
      get :index, recipe_id: recipe.id
      expect(response.body).to eq(recipe.comments.to_json)
    end

    it "return 200 status" do
      get :index, recipe_id: recipe.id
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    it "return an comment for recipe" do
      get :show, recipe_id: recipe.id, id: comment.id
      expect(response.body).to eq(comment.to_json)
    end

    it "return 200 status" do
      get :show, recipe_id: recipe.id, id: comment.id
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create a new comment for recipe" do
        expect{post :create,
        recipe_id: recipe.id,
        comment: attributes_for(:comment)}.to change(Comment, :count).by(1)
      end

      it "return just created comment" do
        post :create,
        recipe_id: recipe.id,
        comment: attributes_for(:comment)
        expect(response.body).to eq(Comment.last.to_json)
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
  end

  describe "DELETE #destroy" do
    it "delete expected comment" do
      expect{delete :destroy,
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