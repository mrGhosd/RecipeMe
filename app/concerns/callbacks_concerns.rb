module CallbacksConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_callback_create_message
    after_destroy :send_callback_destroy_message
    after_update :send_callback_update_message
  end

  def send_callback_create_message
    message({ resource: 'Callback',
              action: 'create',
              id: self.id,
              obj: self
            })
  end

  def send_callback_destroy_message
    message({ resource: 'Callback',
              action: 'destroy',
              id: self.id,
              obj: self })
  end

  def send_callback_update_message
    message({resource: 'Callback',
             action: 'update',
             id: self.id,
             obj: self })
  end
end