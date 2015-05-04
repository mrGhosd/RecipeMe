module NewsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_create_news_message
    after_destroy :send_destroy_news_message
    after_update :send_update_news_message
  end

  def send_create_news_message
   message({ resource: 'News',
             action: 'create',
             id: self.id,
             obj: self})
  end

  def send_destroy_news_message
    message({ resource: 'News',
              action: 'destroy',
              id: self.id,
              obj: self})
  end

  def send_update_news_message
    message({ resource: 'News',
              action: 'update',
              id: self.id,
              obj: self })
  end
end