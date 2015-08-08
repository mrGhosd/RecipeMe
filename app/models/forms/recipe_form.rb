class RecipeForm
  include Tainbox
  include ActiveModel::Validations
  ActiveRecord::NestedAttributes

  attribute :title, String
  attribute :persons, Integer
  attribute :time, Integer
  attribute :difficult, String
  attribute :category, Category
  attribute :image, Image
  attribute :tags, Tag
  attribute :description, String
  attribute :steps
  attribute :ingridients

  validates :title, :description, presence: true
  validates :time, numericality: { only_integer: true }
  validate :difficult_valid?
  validates :persons, numericality: { only_integer: true }

  def submit(params)
    self.attributes = params
    if valid?
      ActiveRecord::Base.transaction do

      end
      true
    else
      false
    end
  end

  def title
    super.try(:strip)
  end

  private

  def difficult_valid?
    if difficult.in?(["easy", "medium", "hard"])
      true
    else
      self.errors[:difficult] << I18n.t("recipes.errors.difficult")
      false
    end
  end
end
