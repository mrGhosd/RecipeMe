class CreateUserUpdates < ActiveRecord::Migration
  def change
    create_table :user_updates do |t|
      t.belongs_to :user, index: true
      t.string :update_type
      t.integer :update_id
      t.string :update_entity, index: true
      t.string :update_entity_for, index: true
      t.string :type, index: true
      t.timestamps
    end
  end
end
