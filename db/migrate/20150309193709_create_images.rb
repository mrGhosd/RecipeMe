class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name, index: true
      t.string :imageable_type
      t.integer :imageable_id, intex: true
      t.timestamps
    end
  end
end
