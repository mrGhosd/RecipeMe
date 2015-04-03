# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

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

end
