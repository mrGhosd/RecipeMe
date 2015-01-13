FactoryGirl.define do
  factory :recipe do
    title 'Title'
    description 'Desc'
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'empty-recipe.png')) }
  end
end