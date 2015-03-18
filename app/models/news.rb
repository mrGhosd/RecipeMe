class News < ActiveRecord::Base
  include Rate
  validates :title, presence: true

end