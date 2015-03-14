class Category < ActiveRecord::Base
  has_many :recipes
  has_one :image, as: :imageable, dependent: :destroy

  def update_image
    current_image = self.image
    last_image = Image.where(imageable_id: self.id).last
    current_image == last_image ? true : self.update(image: last_image)
  end
end