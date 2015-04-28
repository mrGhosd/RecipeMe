module RecipesConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_rate_message, only: [:rating]
    after_action :send_update_recipe_message, only: [:update]
    after_action :send_image_message, only: :create_image
    after_action :send_destroy_recipe_message, only: :destroy
  end

  def send_update_recipe_message
    message({ resource: 'Recipe',
              action: 'attributes-change',
              id: changed_object.id,
              obj: changed_object,
              image: changed_object.image })
  end

  def send_destroy_recipe_message
    message({ resource: 'Recipe',
              action: 'destroy',
              id: @recipe.id,
              obj: @recipe })
  end

  def send_recipe_create_message
    message({ resource: 'Recipe',
              action: 'create',
              id: @recipe.id,
              obj: @recipe,
              image: @recipe.image })
  end
end