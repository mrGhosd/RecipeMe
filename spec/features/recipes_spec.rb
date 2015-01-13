require 'rails_helper'

feature "Recipe for unsigned user ", js: true do
  let!(:recipe){ create :recipe }

  scenario "shows a list of recipes" do
    visit "/"
    click_link "Recipes"
    expect(page).to have_content(recipe.title)
  end
end

feature "Recipe for signed in user", js: true do
  let!(:user) { create :user }
  let!(:user_recipe){ create :recipe }
  let!(:diff_recipe){ create :recipe, user_id: user.id }
end