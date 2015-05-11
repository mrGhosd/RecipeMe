require 'rails_Helper'

describe Step do
  it { should belong_to :recipe }
  it { should have_one :image }

  it { should validate_presence_of :description }
end