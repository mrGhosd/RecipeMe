class CreateReceipies < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.string :image
    end
  end
end
