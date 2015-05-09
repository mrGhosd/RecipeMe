class Category < ActiveRecord::Base
  has_many :recipes
  has_one :image, as: :imageable, dependent: :destroy
  validates :title, :description, presence: :true

  include CategoriesConcerns
  include ImageModel

end