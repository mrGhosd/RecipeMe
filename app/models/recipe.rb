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
  after_create :update_user_recipe

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

  def update_image
    current_image = self.image
    last_image = Image.where(imageable_id: self.id).last
    current_image == last_image ? true : self.update(image: last_image)
  end

  def ingridients_list
    self.ingridients.map do |ingridient|
      ingridient.attributes.merge({size: ingridient.recipe_ingridients.find_by(ingridient_id: ingridient.id).size,
                                  recipe: self.id})
    end
  end

  def created_at_h
    self.created_at.strftime('%H:%M:%S %d.%m.%Y') if self.created_at
  end

  private

  def update_user_recipe
    RecipeUpdate.create(user_id: self.user.id, update_type: 'create',
    update_entity: self.class.to_s, update_entity_for: self.class.to_s, update_id: self.id)
  end
end