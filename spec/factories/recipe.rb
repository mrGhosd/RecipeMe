FactoryGirl.define do
  factory :recipe do
    title 'Title'
    description 'Desc'
    time 45
    persons 4
    difficult "easy"
  end
end