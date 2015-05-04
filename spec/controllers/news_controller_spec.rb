require 'rails_helper'

describe NewsController do
  let!(:user) { create :user }
  let!(:admin) { create :user, email: "olol@mail.ru", role: "admin" }
  let!(:image) { create :image }
  let!(:news) { create :news, image: image }

  describe "GET #index" do
    before { get :index }

    %w(id title text rate image created_at updated_at ).each do |attr|
      it "news attributes contain #{attr}" do
        expect(response.body).to be_json_eql(news.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "render recipes as json" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    before { get :show, id: news.id }
    %w(id title text rate image created_at updated_at ).each do |attr|
      it "news attributes contain #{attr}" do
        expect(response.body).to be_json_eql(news.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "render recipes as json" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    before { login_as admin }

    context "with valid attributes" do
      it "create a new news" do
        expect{ post :create, news: attributes_for(:news) }.to change(News, :count).by(1)
      end

      it "return 200 status" do
        post :create, news: attributes_for(:news)
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a news" do
        expect{ post :create, news: attributes_for(:news, title: "") }.to change(News, :count).by(0)
      end

      it "return array with errors" do
        post :create, news: attributes_for(:news, title: "")
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end

  describe "PUT #update" do
    before { login_as admin }

    context "with valid attributes" do
      it "update news" do
        put :update, id: news.id, news: attributes_for(:news, title: "1")
        news.reload
        expect(news.title).to eq("1")
      end

      it "return 200 status" do
        put :update, id: news.id, news: attributes_for(:news, title: "1")
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a news" do
        put :update, id: news.id, news: attributes_for(:news, title: "")
        news.reload
        expect(news.title).to eq(news.title)
      end

      it "return array with errors" do
        post :create, news: attributes_for(:news, title: "")
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end

  end

  describe "DELETE #destroy" do
    before { login_as admin }

    it "delete a news" do
      expect {delete :destroy, id: news.id }.to change(News, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy, id: news.id
      expect(response.status).to eq(200)
    end
  end
end