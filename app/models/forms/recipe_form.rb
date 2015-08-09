class RecipeForm
  include Tainbox
  include ActiveModel::Validations
  include ActiveRecord::NestedAttributes

  attribute :title, String
  attribute :persons, Integer
  attribute :time, Integer
  attribute :difficult, String
  attribute :category_id, Integer
  attribute :user_id, Integer
  attribute :tag_list, String
  attribute :description, String


  # validates :image, presence: true

  def submit(params)
    @params = params
    self.attributes = @params
    binding.pry
    if valid? && attributes_valid?
      ActiveRecord::Base.transaction do
        @recipe = Recipe.new(attributes)
        @recipe.save
        set_image_for_recipe
        set_steps_for_recipe
      end
    else
      false
    end
  end

  def title
    super.try(:strip)
  end

  private

  def set_image_for_recipe
    @recipe.image = Image.find(@params["image"]["id"]) if @params["image"]["id"].present?
  end

  def set_steps_for_recipe
    @params["steps"].each do |step|
      step_node = Step.new(step)
    end
  end

  def check_image
    false if image.blank?
  end

  def attributes_valid?
    image_valid? && steps_valid?
  end

  def image_valid?
    @params["image"].present? ? true : self.errors.add(:image, "can't be blank"); false
  end

  def steps_valid?
    @form = self
    @params["steps"].each do |params|
      image = Image.find(params["image"]["id"]) if params["image"].present?
      step = Step.new({description: params["description"], image: image})
      if step.invalid?
        self.errors.add(:steps, step.errors.messages)
      end
    end
    self.errors[:steps].any? ? false : true
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
