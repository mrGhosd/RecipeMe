class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  mount_uploader :name, ImageUploader


  def self.destroy_useless_images
    self.where(imageable_id: nil).destroy_all
  end
end