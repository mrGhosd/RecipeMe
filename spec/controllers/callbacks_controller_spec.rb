require 'rails_helper'

describe CallbacksController do
  let!(:user){ create :user }
  let!(:callback) { create :callback }

  describe "GET #index" do
    before { get :index }

    %w(id author text).each do |attr|
      it "callback contain #{attr}" do
        expect(response.body).to be_json_eql(callback.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "render 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "user signed in" do
      before do
        login_as user
      end
      context "with valid attributes" do
        it "create a new callback" do
          expect{ post :create, callback: attributes_for(:callback, user_id: user.id) }.to change(::Callback, :count).by(1)
        end

        it "return just created callback" do
          post :create, callback: attributes_for(:callback, user_id: user.id)
          expect(response.body).to eq(::Callback.last.to_json)
        end
      end

      context "with invalid attributes" do
        it "doesn't create a callback" do
          expect{ post :create, callback: attributes_for(:callback, text: "", user_id: user.id) }.to change(::Callback, :count).by(0)
        end

        it "return array with error messages" do
          post :create, callback: attributes_for(:callback, text: "", user_id: user.id)
          expect(JSON.parse(response.body)).to have_key("text")
        end
      end
    end
  end

  describe "PUT #update" do
    before { login_as user }

    context "with valid attributes" do
      it "update an callback" do
        put :update, id: callback.id, callback: attributes_for(:callback, user_id: user.id, text: "2")
        callback.reload
        expect(callback.text).to eq("2")
      end

      it "return just updated callback" do
        put :update, id: callback.id, callback: attributes_for(:callback, user_id: user.id, text: "2")
        callback.reload
        expect(response.body).to eq(callback.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't update a callback" do
        put :update, id: callback.id, callback: attributes_for(:callback, user_id: user.id, text: "")
        callback.reload
        expect(callback.text).to eq(callback.text)
      end

      it "return array with error messages" do
        put :update, id: callback.id, callback: attributes_for(:callback, user_id: user.id, text: "2")
        callback.reload
        expect(JSON.parse(response.body)).to have_key("text")
      end
    end
  end

  describe "DELETE #destroy" do
    before { login_as user }

    it "destroy callback" do
      expect{ delete :destroy, id: callback.id }.to change(Callback, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy, id: callback.id
      expect(response.status).to eq(200)
    end
  end
end