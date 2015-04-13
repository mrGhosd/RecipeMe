class RecipeIngridient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingridient

  def self.find_by_or_create(args)
    connection = self.where(recipe_id: args[:recipe_id], ingridient_id: args[:ingridient_id])
    if connection
      connection = only_on_ingridient_for_recipe(connection) if connection.count > 1
      connection.last.update(size: args[:size])
    else
      binding.pry
      self.create(args)
    end
  end

  private

  def only_on_ingridient_for_recipe(ingridients_list)
    binding.pry
  end
end