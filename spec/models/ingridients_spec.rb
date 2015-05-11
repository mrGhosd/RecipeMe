require 'rails_helper'

describe Ingridient do
  it { should have_many :recipe_ingridients }
  it { should have_many :recipes }

  it { validate_presence_of :name }
  it { validate_uniqueness_of :name }
end