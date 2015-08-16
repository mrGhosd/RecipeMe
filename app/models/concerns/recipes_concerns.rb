module RecipesConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_update :send_update_recipe_message
    after_create :send_recipe_create_message
    after_destroy :send_destroy_recipe_message
  end

  def send_destroy_recipe_message
    message({ resource: 'Recipe',
              action: 'destroy',
              id: self.id,
              obj: self })
  end

  def send_recipe_create_message
    message({ resource: 'Recipe',
              action: 'create',
              id: self.id,
              obj: self.as_json(methods: [:image, :user]) })
  end

  def send_update_recipe_message
    message({ resource: 'Recipe',
              action: 'attributes-change',
              id: self.id,
              obj: self.as_json(methods: [:image, :user]) })
  end
end