class News < ActiveRecord::Base
  has_one :image, as: :imageable, dependent: :destroy
  validates :title, presence: true
  include Rate
  include ImageModel
end