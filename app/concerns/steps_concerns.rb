module StepsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_create_step_message, only: :create
    after_action :send_destroy_step_message, only: :destroy
    after_action :send_update_step_message, only: :update
  end

  def send_create_step_message
    message({ resource: 'Step',
              action: 'create',
              id: @recipe.id,
              obj: @step })
  end

  def send_update_step_message
    message({ resource: 'Step',
              action: 'update',
              id: @recipe.id,
              obj: @step })
  end

  def send_destroy_step_message
    message({ resource: 'Step',
              action: 'destroy',
              id: @recipe.id,
              obj: @step })
  end
end