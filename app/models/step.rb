class Step < ActiveRecord::Base
  belongs_to :recipe
  has_one :image, as: :imageable
end