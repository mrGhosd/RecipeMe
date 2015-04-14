class Category < ActiveRecord::Base
  has_many :recipes
  has_one :image, as: :imageable, dependent: :destroy
  include ImageModel

end