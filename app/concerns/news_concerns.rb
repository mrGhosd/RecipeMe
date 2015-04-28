module NewsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_create_news_message, only: :create
    after_action :send_image_message, only: :create_image
    after_action :send_destroy_news_message, only: :destroy
    after_action :send_update_news_message, only: :update
    after_action :send_rate_message, only: [:rating]
  end

  def send_create_news_message
   message({ resource: 'News',
             action: 'create',
             id: @news.id,
             obj: @news})
  end

  def send_destroy_news_message
    message({ resource: 'News',
              action: 'destroy',
              id: @news.id,
              obj: @news})
  end

  def send_update_news_message
    message({ resource: 'News',
              action: 'update',
              id: @news.id,
              obj: @news })
  end
end