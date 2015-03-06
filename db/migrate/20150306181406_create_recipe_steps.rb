class CreateRecipeSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.belongs_to :recipe
      t.text :description
      t.string :image
      t.timestamps
    end
  end
end
