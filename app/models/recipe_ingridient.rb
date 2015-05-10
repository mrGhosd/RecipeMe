class RecipeIngridient < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :ingridient, dependent: :destroy

  after_create :increment_counter
  after_destroy :decrement_counter
  include IngridientsConcerns

  def self.find_by_or_create(args)
    connection = self.where(recipe_id: args[:recipe_id], ingridient_id: args[:ingridient_id])
    if connection
      connection = self.only_on_ingridient_for_recipe(connection) if connection.count > 1
      connection.last.update(size: args[:size])
    else
      self.create(args)
    end
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