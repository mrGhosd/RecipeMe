class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_one :image, as: :imageable, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  acts_as_taggable

  validates :title, :description, presence: true

  accepts_nested_attributes_for :steps

  def images
    {small: self.image.url(:small),
    normal: self.image.url(:normal)}
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(value)
    self.tags = names.split(",").map do |n|
      ActsAsTaggableOn::Tag.where(name: n.strip).first_or_create!
    end
  end
end