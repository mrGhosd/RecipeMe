require 'rails_helper'

describe Recipe do
  let!(:category) { create :category }
  let!(:user) { create :user }
  let!(:recipe) { create :recipe }
end
