module IngridientsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_create_ingridient_action
    after_destroy :send_destroy_ingridient_action
  end

  def send_create_ingridient_action
    msg = { resource: 'Ingridient',
            action: 'create',
            id: self.recipe.id,
            obj: self.ingridient,
            size: self.size}
    message(msg)
  end

  def send_destroy_ingridient_action
    msg = { resource: 'Ingridient',
            action: 'destroy',
            id: self.recipe.id,
            obj: self.ingridient}
    message(msg)
  end

end