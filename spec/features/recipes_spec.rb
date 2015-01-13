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
  let!(:diff_recipe){ create :recipe, title: "User Recipe", user_id: user.id }

  before do
    sign_in user
    sleep 1
    click_link "Recipes"
  end

  scenario "See the list of recipes" do
    expect(page).to have_content(user_recipe.title)
    expect(page).to have_content(diff_recipe.title)
    expect(page).to have_css(".sign-out-button")
  end

  scenario "show recipe full info" do
    find(".recipe-list-item .image", match: :first).hover
    expect(page).to have_css(".glyphicon-book")

    page.all(".recipe-list-item .image")[1].hover
    expect(page).to have_css(".glyphicon-book")
    expect(page).to have_css(".glyphicon-edit")
    expect(page).to have_css(".glyphicon-remove")
  end
end