FactoryGirl.define do
  factory :recipe do
    before(:create)do |recipe|
      recipe.image =  Image.new
    end

    title 'Title'
    description 'Desc'
    time 45
    persons 4
    difficult "easy"
  end
end