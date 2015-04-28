module IngridientsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_create_ingridient_action, only: :create
    after_action :send_destroy_ingridient_action, only: :destroy
  end

  def send_create_ingridient_action
    message({ resource: 'Ingridient',
              action: 'create',
              id: @recipe.id,
              obj: @ingridient,
              size: params[:in_size]})
  end

  def send_destroy_ingridient_action
    message({ resource: 'Ingridient',
              action: 'destroy',
              id: @recipe.id,
              obj: @ingridient,
              size: params[:in_size]})
  end

end