module IngridientsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_create_ingridient_action
    after_destroy :send_destroy_ingridient_action
  end

  def send_create_ingridient_action
    message({ resource: 'Ingridient',
              action: 'create',
              id: self.id,
              obj: self,
              size: self.recipe_ingridients.last.size})
  end

  def send_destroy_ingridient_action
    message({ resource: 'Ingridient',
              action: 'destroy',
              id: self.id,
              obj: self,
              size: params[:in_size]})
  end

end