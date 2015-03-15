class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :voteable_id, index: true
      t.string :voteable_type, index: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
