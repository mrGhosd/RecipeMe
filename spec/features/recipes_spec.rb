require 'rails_helper'

feature "Recipe for unsigned user ", js: true do
  let!(:recipe){ create :recipe }

  scenario "shows a list of recipes" do
    visit "/"
    click_link "Recipes"
  end
end