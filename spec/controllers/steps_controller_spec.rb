require 'rails_helper'

describe StepsController do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }
  let!(:step) { create :step, recipe_id: recipe.id }
  let!(:image) { create :image, imageable_id: step.id, imageable_type: "Step" }
  describe "GET #index" do
    before { get :index, recipe_id: recipe.id, id: step.id }

    it "return an list of steps for recipe" do
      expect(response.body).to eq(recipe.steps.to_json(methods: :image))
    end

    it "return an json with status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    before { get :show, recipe_id: recipe.id, id: step.id }

    it "return an list of steps for recipe" do
      expect(response.body).to eq(recipe.steps.to_json(methods: :image))
    end

    it "return an json with status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create a new step" do
        expect{ post :create, recipe_id: recipe.id, description: "1" }.to change(Step, :count).by(1)
      end

      it "return this step " do
        post :create, recipe_id: recipe.id, description: "1"
        expect(response.body).to eq(Step.last.to_json)
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      before { put :update, recipe_id: recipe.id, id: step.id, description: "1" }

      it "define an updated step" do
        expect(assigns(:step)).to eq step
      end

      it "return an updated step" do
        expect(response.body).to eq(assigns(:step).to_json)
      end
    end
  end

  describe "DELETE #destroy" do
    it "delete particular step" do
      expect{ delete :destroy, recipe_id: recipe.id, id: step.id }.to change(Step, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy, recipe_id: recipe.id, id: step.id
      expect(response.status).to eq(200)
    end
  end
end