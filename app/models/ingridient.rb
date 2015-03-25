class Ingridient < ActiveRecord::Base
  has_many :recipe_ingridients, dependent: :destroy
  has_many :recipes, through: :recipe_ingridients

  validates :name, uniqueness: true
  attr_accessor :size
end