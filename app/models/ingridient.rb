class Ingridient < ActiveRecord::Base
  has_many :recipe_ingridients
  has_many :recipes, through: :recipe_ingridients

  validates :name, uniqueness: true, presence: true
end