class AddRecipeAttributes < ActiveRecord::Migration
  def change
    add_column :recipes, :time, :integer, default: 0
    add_column :recipes, :persons, :integer, default: 1
    add_column :recipes, :difficult, :string

    add_index :recipes, :time
    add_index :recipes, :persons
    add_index :recipes, :difficult
  end
end
