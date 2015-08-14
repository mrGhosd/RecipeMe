class AddDeltaToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :delta, :boolean, :default => true, :null => false
    add_index :recipes, :delta
  end
end
