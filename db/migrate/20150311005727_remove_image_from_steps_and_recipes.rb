class RemoveImageFromStepsAndRecipes < ActiveRecord::Migration
  def change
    remove_column :recipes, :image, :string
    remove_column :steps, :image, :string
  end
end
