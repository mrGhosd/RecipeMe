require 'rails_helper'

describe StepsController do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }
  let!(:step) { create :step, recipe_id: recipe.id }
  let!(:image) { create :image, imageable_id: step.id, imageable_type: "Step" }

  before { login_as user }

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