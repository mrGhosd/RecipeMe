class RecipeForm
  include Tainbox
  include ActiveModel::Validations
  ActiveRecord::NestedAttributes

  attribute :title
  attribute :image, Image

  validates_presence_of :title

  def submit(params)
    self.attributes = params
    if valid?
      true
    else
      false
    end
  end

  def title
    super.try(:strip)
  end

  def image
  end
end
