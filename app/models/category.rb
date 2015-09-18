class Category < ActiveRecord::Base
  extend FriendlyId

  has_many :recipes
  has_one :image, as: :imageable, dependent: :destroy
  validates :title, :description, presence: :true
  friendly_id :title, use: [:slugged, :finders]

  include CategoriesConcerns
  include ImageModel
  include SlugTranslate
end