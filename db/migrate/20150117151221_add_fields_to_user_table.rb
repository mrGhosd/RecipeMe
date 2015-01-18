class AddFieldsToUserTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :surname
      t.string :name
      t.string :nickname
      t.datetime :date_of_birth
      t.string :city
      t.string :avatar
    end
  end
end
