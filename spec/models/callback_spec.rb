require 'rails_helper'

describe Callback do
  it { should belong_to :user }

  it { should validate_presence_of :author }
  it { should validate_presence_of :text }
end