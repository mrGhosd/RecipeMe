class Step < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  has_one :image, as: :imageable, dependent: :destroy
  include ImageModel
  include StepsConcerns

  validates :description, presence: true
  # validates :image, presence: true
end