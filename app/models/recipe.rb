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
  after_create :send_message_to_author_followers unless Rails.env == "development"
  after_destroy :destroy_recipe

  validates :title, :description, presence: true
  validates :time, numericality: { only_integer: true }
  validate :difficult_valid?
  validates :persons, numericality: { only_integer: true }


  accepts_nested_attributes_for :steps
  include RecipesConcerns
  include RateModel
  include ImageModel

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def self.filter(params)
    attribute = params[:filter_attr] || "rate"
    order = params[:filter_order] || "desc"
    self.order(attribute => order)
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      ActsAsTaggableOn::Tag.where(name: n.strip).first_or_create!
    end
  end

  def comments_list
    self.comments.order(created_at: :desc).limit(5)
  end

  def steps_list
    self.steps.order(created_at: :asc).as_json(methods: :image)
  end

  def ingridients_list
    self.ingridients.uniq.map do |ingridient|
      ingridient.attributes.merge({size: ingridient.recipe_ingridients.find_by(ingridient_id: ingridient.id).size,
                                  recipe: self.id})
    end
  end

  def votes
    Vote.where(voteable_id: self.id).map(&:user_id)
  end

  def created_at_h
    self.created_at.strftime('%H:%M:%S %d.%m.%Y') if self.created_at
  end

  private

  def update_user_recipe
    RecipeUpdate.create(user_id: self.user.id, update_type: 'create',
    update_entity: self.class.to_s, update_entity_for: self.class.to_s, update_id: self.id)
  end

  def send_message_to_author_followers
    self.user.followers.each do |follower|
      RecipesMailer.delay.create_message(follower, self.user, self)
    end
  end

  def destroy_recipe
    if self.present?
      RecipeUpdate.where(update_entity: self.class.to_s, update_id: self.id).delete_all
      Vote.where(voteable_id: self.id, voteable_type: self.class.to_s).delete_all
    end
  end

  def difficult_valid?
    if difficult.in?(["easy", "medium", "hard"])
      true
    else
      self.errors[:difficult] << I18n.t("recipes.errors.difficult")
      false
    end
  end

end