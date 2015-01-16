require 'rails_helper'

feature "Recipe comments for unsigned user", js: true do
  let!(:recipe) { create :recipe }
  let!(:comment) { create :comment, recipe_id: recipe.id }

  scenario "show a list of comments for recipe" do
    visit "/"
    click_link "Recipes"
    page.all(".recipe-list-item .image")[0].hover
    find(".glyphicon-book").click
    binding.pry
    expect(page).to have_content(comment.text)
  end
end