class AddCountersForRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :comments_count, :integer, default: 0
    add_column :recipes, :steps_count, :integer, default: 0
    add_column :recipes, :recipe_ingridients_count, :integer, default: 0
  end
end
