FactoryGirl.define do
  factory :step do
    before(:create)do |step|
      step.image =  create(:image)
    end

    description 'Step description'
  end
end