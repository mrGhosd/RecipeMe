require 'rails_helper'

describe RelationshipsController do
  let!(:user) { create :user }
  let!(:follower) { create :user }

  before { login_as user }

  describe "POST #create" do
    context "correct format" do
      before { post :create, id: follower.id, format: :json }

      it "increase user followers count" do
        expect(follower.followers).to eq([user])
      end

      it "return user" do
        expect(response.body).to eq(follower.to_json)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      user.follow! follower
      delete :destroy, id: follower.id, format: :json
    end

    it "decrease user followers count" do
      expect(follower.followers).to eq([])
    end

    it "return user" do
      expect(response.body).to eq(follower.to_json)
    end
  end
end