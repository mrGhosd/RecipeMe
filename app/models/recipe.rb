class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  mount_uploader :image, RecipeUploader

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end
end