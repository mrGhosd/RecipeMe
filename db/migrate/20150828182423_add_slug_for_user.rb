class AddSlugForUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, uniq: true, index: true
  end
end
