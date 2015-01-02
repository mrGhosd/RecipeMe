class Comment <ActiveRecord::Base
  belongs_to :recipes
  belongs_to :users

  validates :text, presence: true
end