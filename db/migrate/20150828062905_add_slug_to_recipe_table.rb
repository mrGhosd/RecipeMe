class AddSlugToRecipeTable < ActiveRecord::Migration
  def change
    add_column :recipes, :slug, :string, uniq: true, index: true
  end
end
