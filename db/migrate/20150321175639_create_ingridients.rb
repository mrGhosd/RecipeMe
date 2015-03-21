class CreateIngridients < ActiveRecord::Migration
  def change
    create_table :ingridients do |t|
      t.string :name, index: true
      t.timestamps
    end
  end
end
