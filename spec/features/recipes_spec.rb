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
  let!(:diff_recipe){ create :recipe }
  let!(:user_recipe){ create :recipe, title: "User Recipe", user_id: user.id }

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

  scenario "show recipe actions" do
    find(".recipe-list-item .image", match: :first).hover
    expect(page).to have_css(".glyphicon-book")

    page.all(".recipe-list-item .image")[1].hover
    expect(page).to have_css(".glyphicon-book")
    expect(page).to have_css(".glyphicon-edit")
    expect(page).to have_css(".glyphicon-remove")
  end

  scenario "show recipe full actions" do
    page.all(".recipe-list-item .image")[0].hover
    find(".glyphicon-book").click
    expect(page).to have_content(diff_recipe.title)
    expect(page).to have_content(diff_recipe.description)
    expect(page).to have_css(".add-comment-button")
    expect(page).to have_css(".back-button")
  end

  context "with valid attributes" do
    scenario "create a new recipe" do
      find(".add-recipe").click
      expect(page).to have_css("#recipe_form")
      find(".recipe-title").set("NEWTITLE")
      find(".recipe-description").set("NEWDESCRIPTION")
      attach_file "recipe_image", "#{Rails.root}/app/assets/images/empty-recipe.png"
      find(".submit-form").click
      sleep 1
      expect(page).to have_content("NEWTITLE")
    end

    scenario "update an old recipe" do
      page.all(".recipe-list-item .image")[1].hover
      find(:css, ".glyphicon-edit").click
      expect(page).to have_css("#recipe_form")
      find(".recipe-title").set("NEWOLDTITLE")
      find(".submit-form").click
      sleep 1
      expect(page).to_not have_content(user_recipe.title)
      expect(page).to have_content("NEWOLDTITLE")
    end
  end
end