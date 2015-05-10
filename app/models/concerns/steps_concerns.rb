module StepsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_create_step_message
    after_destroy :send_destroy_step_message
    after_update :send_update_step_message
  end

  def send_create_step_message
    message({ resource: 'Step',
              action: 'create',
              id: self.recipe.id,
              obj: self })
  end

  def send_update_step_message
    message({ resource: 'Step',
              action: 'update',
              id: self.recipe.id,
              obj: self })
  end

  def send_destroy_step_message
    message({ resource: 'Step',
              action: 'destroy',
              id: self.recipe.id,
              obj: self })
  end
end