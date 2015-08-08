class RecipeIngridient < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :ingridient, dependent: :destroy

  after_create :increment_counter
  after_destroy :decrement_counter

  accepts_nested_attributes_for :ingridient
  include IngridientsConcerns

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