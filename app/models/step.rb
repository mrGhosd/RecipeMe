class Step < ActiveRecord::Base
  belongs_to :recipe
  has_one :image, as: :imageable, dependent: :destroy

  def illustration
    self.image
  end

  def update_image
    current_image = self.image
    last_image = Image.where(imageable_id: self.id).last
    current_image == last_image ? true : self.update(image: last_image)
  end
end