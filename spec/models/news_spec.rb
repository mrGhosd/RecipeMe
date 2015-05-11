require 'rails_helper'

describe News do
  it { should have_one :image }

  it { should validate_presence_of :title }
  it { should validate_presence_of :text }
end