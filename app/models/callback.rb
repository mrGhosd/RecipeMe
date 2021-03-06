class Callback < ActiveRecord::Base
  belongs_to :user

  validates :author, :text, presence: true
  include CallbacksConcerns
end