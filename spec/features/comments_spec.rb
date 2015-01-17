require 'rails_helper'

feature "Recipe comments for unsigned user", js: true do
  let!(:recipe) { create :recipe }
  let!(:comment) { create :comment, recipe_id: recipe.id }

  scenario "show a list of comments for recipe" do
    visit "/"
    click_link "Recipes"
    page.all(".recipe-list-item .image")[0].hover
    find(".glyphicon-book").click
    expect(page).to have_content(comment.text)
  end
end

feature "Recipe comments for signed in user", js: true do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }
  let!(:comment) { create :comment, recipe_id: recipe.id, user_id: user.id }
  let!(:diff_comment) { create :comment, text: "awdawdaw", recipe_id: recipe.id }

  before do
    sign_in user
    sleep 1
    click_link "Recipes"
    page.all(".recipe-list-item .image")[0].hover
    find(".glyphicon-book").click
  end

  scenario "See the list of comments for recipe" do
    expect(page).to have_content(comment.text)
    expect(page).to have_content(diff_comment.text)
  end

  scenario "find edit and destroy buttons
  in comment block if it belongs_to user" do
    expect(page).to have_css(".glyphicon-pencil")
    expect(page).to have_css(".glyphicon-remove")
  end

  context "with valid attributes" do
    scenario "create a comment" do
      expect(page).to have_css(".glyphicon-plus")
      find(".glyphicon-plus").click
      expect(page).to have_css("#comment_form")
      find(".recipe-title").set("VALUE")
      click_button "Save"
      expect(page).to have_content("VALUE")
    end
  end

  context "with invalid attributes" do
    scenario "create a comment" do
      expect(page).to have_css(".glyphicon-plus")
      find(".glyphicon-plus").click
      expect(page).to have_css("#comment_form")
      click_button "Save"
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end
  end
end