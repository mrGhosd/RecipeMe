class CreateUserUpdates < ActiveRecord::Migration
  def change
    create_table :user_updates do |t|
      t.string :update_type
      t.integer :update_id
      t.string :update_entity
      t.timestamps
    end
  end
end
