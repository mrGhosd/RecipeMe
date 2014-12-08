class Recipe < ActiveRecord::Base
  mount_uploader :image, RecipeUploader

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end
end