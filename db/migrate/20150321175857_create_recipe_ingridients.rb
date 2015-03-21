class CreateRecipeIngridients < ActiveRecord::Migration
  def change
    create_table :recipe_ingridients do |t|
      t.belongs_to :recipe
      t.belongs_to :ingridient
      t.string :size
      t.timestamps
    end
  end
end
