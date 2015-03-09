class Step < ActiveRecord::Base
  belongs_to :recipe
  has_one :image, as: :imageable, dependent: :destroy
end