class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.belongs_to :user
      t.integer :complaintable_id, index: true
      t.string :complaintable_type, index: true
      t.timestamps
    end
  end
end
