# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  after :store, :update_image

  def default_url(*args)
    "/images/user8_256.png"
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end
  version :small do
    process :resize_to_fit => [200,200]
  end

  version :normal do
    process :resize_to_fit => [350,350]
  end

  def update_image(file)
    if self.model.changed?
      Journal.where("user.id" => self.model.id).update_all({"user.name" => self.model.correct_naming,
                                                      "user.avatar_url" => self.model.avatar.url})
    end
  end
end
