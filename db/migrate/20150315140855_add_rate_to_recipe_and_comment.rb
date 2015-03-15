class AddRateToRecipeAndComment < ActiveRecord::Migration
  def change
    add_column :recipes, :rate, :integer, default: 0
    add_column :comments, :rate, :integer, default: 0
  end
end
