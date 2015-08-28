class AddFriendlyIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string, uniq: true, index: true
  end
end
