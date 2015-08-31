module UsersConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_save :send_update_user_data
  end


  def send_update_user_data
    message({ resource: 'User',
              action: 'update',
              id: self.id,
              obj: self })
  end
end