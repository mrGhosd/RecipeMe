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

    context "imageable_id doesn't blank" do
      let!(:image) { create :image, imageable_id: recipe.id, imageable_type: recipe.class.to_s }
      it "update existing image" do
        post :create, imageable_id: recipe.id, imageable_type: recipe.class.to_s, name: fixture_file_upload("/images/b.png", 'image/png')
        image.reload
        expect(image.name.url).to eq("/uploads/image/#{image.id}/b.png")
      end

      it "return w00 status" do
        post :create, imageable_id: recipe.id, imageable_type: recipe.class.to_s, name: fixture_file_upload("/images/b.png", 'image/png')
        expect(response.status).to eq(200)
      end

    end
  end
end