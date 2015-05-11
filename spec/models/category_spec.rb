require 'rails_helper'

describe Category do
  it { should have_many :recipes }
  it { should have_one :image }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description}
end

