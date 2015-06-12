require 'rails_helper'

describe "API Recipes controller" do
  let!(:api_path) { "/api/v1/recipes" }
  it_behaves_like "API Authenticable"
end