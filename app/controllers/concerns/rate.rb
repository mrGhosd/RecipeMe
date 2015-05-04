module Rate
  include WebsocketsMessage
  include ChangeObject
  extend ActiveSupport::Concern

  included do
    after_action :send_rate_message, only: [:rating]
  end

  def rating
    if changed_object.update_rating(current_user)
      render json: {rate: changed_object.rate}, status: :ok
    else
      render json: changed_object.errors.to_json, status: :uprocessible_entity
    end
  end

  def send_rate_message
    message({ resource: changed_object.class.to_s,
              action: 'rate',
              id: changed_object.id,
              obj: changed_object })
  end
end