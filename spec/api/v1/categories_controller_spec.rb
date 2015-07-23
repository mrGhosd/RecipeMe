require 'rails_helper'

describe "Categories API controller" do
  let!(:access_token) { create :access_token }
  let!(:category) { create :category }

  describe "GET #index" do
    before { get "/api/v1/categories", access_token: access_token.token, format: :json }

    %w(id title description ).each do |attr|
      it "category in categories list contains #{attr}" do
        expect(response.body).to be_json_eql(category.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end
end