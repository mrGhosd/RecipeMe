FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "ololosh#{n}@mail.ru" }
    password '666777111'
  end
end
