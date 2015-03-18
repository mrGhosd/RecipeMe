class Callback < ActiveRecord::Base
  belongs_to :user

  validates :author, presence: true
end