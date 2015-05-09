module CategoriesConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_create_category_message
    after_destroy :send_destroy_category_message
    after_update :send_update_category_message
  end

  def send_create_category_message
    message({ resource: 'Category',
              action: 'create',
              id: self.id,
              obj: self,
              image: self.image})
  end

  def send_destroy_category_message
    message({ resource: 'Category',
              action: 'destroy',
              id: self.id,
              obj: self})
  end

  def send_update_category_message
    message({ resource: 'Category',
              action: 'update',
              id: self.id,
              obj: self})
  end
end