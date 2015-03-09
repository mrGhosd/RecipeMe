class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :steps
  has_one :image, as: :imageable
  mount_uploader :image, RecipeUploader

  validates :title, :description, presence: true

  accepts_nested_attributes_for :steps

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end
end