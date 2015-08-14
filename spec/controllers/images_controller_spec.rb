require 'rails_helper'

describe ImagesController do
  let!(:user) { create :user }
  let!(:recipe){ create :recipe, user_id: user.id }

  before { login_as user }

  describe "POST #create" do
    context "imageable_id blank" do
      it "create a new image" do
        expect{ post :create,
        imageable_type: recipe.class.to_s }.to change(Image, :count).by(1)
      end

      it "return 200 status" do
        post :create, imageable_type: recipe.class.to_s
        expect(response.status).to eq(200)
      end
    end
  end
end