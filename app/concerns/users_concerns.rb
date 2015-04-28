module UsersConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_update_user_data, only: :update
  end


  def send_update_user_data
    message({ resource: 'User',
              action: 'update',
              id: @user.id,
              obj: @user })
  end
end