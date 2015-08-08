class RecipeForm
  include Tainbox
  include ActiveModel::Validations
  ActiveRecord::NestedAttributes

  attribute :title, String
  attribute :persons, Integer
  attribute :time, Integer
  attribute :difficult, String
  attribute :category_id, Integer
  attribute :user_id, Integer
  attribute :tags, Tag
  attribute :description, String
  attribute :image

  validates :title, :description, presence: true
  validates :time, numericality: { only_integer: true }
  validate :difficult_valid?
  validates :persons, numericality: { only_integer: true }
  validates :image, presence: true

  def submit(params)
    self.attributes = params
    if valid?
      ActiveRecord::Base.transaction do
        binding.pry
      end
    else
      false
    end
  end

  def title
    super.try(:strip)
  end

  private

  def check_image
    false if image.blank?
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
