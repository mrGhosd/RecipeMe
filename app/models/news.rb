class News < ActiveRecord::Base
  has_one :image, as: :imageable, dependent: :destroy
  validates :title, :text, presence: true

  include NewsConcerns
  include RateModel
  include ImageModel
end