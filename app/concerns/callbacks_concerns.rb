module CallbacksConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_callback_create_message, only: :create
    after_action :send_callback_destroy_message, only: :destroy
    after_action :send_callback_update_message, only: :update
  end

  def send_callback_create_message
    message({ resource: 'Callback',
              action: 'create',
              id: @callback.id,
              obj: @callback
            })
  end

  def send_callback_destroy_message
    message({ resource: 'Callback',
              action: 'destroy',
              id: @callback.id,
              obj: @callback })
  end

  def send_callback_update_message
    message({resource: 'Callback',
             action: 'update',
             id: @callback.id,
             obj: @callback })
  end
end