module CategoriesConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_create_category_message, only: :create
    after_action :send_destroy_category_message, only: :destroy
    after_action :send_update_category_message, only: :update
    after_action :send_image_message, only: :create_image
  end

  def send_create_category_message
    message({ resource: 'Category',
              action: 'create',
              id: @category.id,
              obj: @category,
              image: @category.image})
  end

  def send_destroy_category_message
    message({ resource: 'Category',
              action: 'destroy',
              id: @category.id,
              obj: @category})
  end

  def send_update_category_message
    message({ resource: 'Category',
              action: 'update',
              id: @category.id,
              obj: @category})
  end
end