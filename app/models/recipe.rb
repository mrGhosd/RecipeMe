class Recipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_one :image, as: :imageable, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :recipe_ingridients
  has_many :ingridients, through: :recipe_ingridients
  acts_as_taggable

  validates :title, :description, presence: true

  accepts_nested_attributes_for :steps
  include Rate

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      ActsAsTaggableOn::Tag.where(name: n.strip).first_or_create!
    end
  end
end