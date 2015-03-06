class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :steps
  mount_uploader :image, RecipeUploader

  validates :title, :description, presence: true

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end
end