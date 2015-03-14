class AddTimestampsAndCategoryIDtoRecipes < ActiveRecord::Migration
  def change
    change_table :recipes do |t|
      t.belongs_to :category, index: true
      t.timestamps
    end
  end
end
