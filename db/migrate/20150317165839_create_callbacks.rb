class CreateCallbacks < ActiveRecord::Migration
  def change
    create_table :callbacks do |t|
      t.belongs_to :user
      t.string :author
      t.text :text
      t.timestamps
    end
  end
end
