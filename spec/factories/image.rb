FactoryGirl.define do
  factory :image do
    name { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'empty-recipe.png')) }
  end
end