class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title, index: true
      t.text :text
      t.integer :rate, index: true, default: 0
      t.timestamps
    end
  end
end
