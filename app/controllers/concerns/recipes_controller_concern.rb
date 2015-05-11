module RecipesControllerConcern
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_update_recipe_message, only: :update
  end

  def send_update_recipe_message
    message({ resource: 'Recipe',
              action: 'attributes-change',
              id: @recipe.id,
              obj: @recipe,
              image: @recipe.image })
  end
end

