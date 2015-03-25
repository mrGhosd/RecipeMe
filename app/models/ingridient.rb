class Ingridient < ActiveRecord::Base
  has_many :recipe_ingridients
  has_many :recipes, through: :recipe_ingridients, dependent: :destroy

  validates :name, uniqueness: true
  attr_accessor :size
end