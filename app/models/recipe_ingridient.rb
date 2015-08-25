class RecipeIngridient < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :ingridient, dependent: :destroy

  after_create :increment_counter
  after_destroy :decrement_counter

  validates :size, presence: true
  accepts_nested_attributes_for :ingridient
  include IngridientsConcerns

  validate do |recipe_ingridient|
    if recipe_ingridient.ingridient && recipe_ingridient.ingridient.try(:invalid?)
      self.errors.add(:name, recipe_ingridient.ingridient.errors.messages)
    end

  end

  def ingridient_attributes=(attr)
    self.ingridient = Ingridient.find_by(name: attr[:name]) || Ingridient.new(name: attr[:name])
  end

  def increment_counter
    Recipe.increment_counter(:recipe_ingridients_count, recipe.id)
  end

  def decrement_counter
    Recipe.decrement_counter(:recipe_ingridients_count, self.id)
  end

  private

  def only_on_ingridient_for_recipe(ingridients_list)

  end
end