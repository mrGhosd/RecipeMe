class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_one :image, as: :imageable, dependent: :destroy

  validates :title, :description, presence: true

  accepts_nested_attributes_for :steps

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end
end