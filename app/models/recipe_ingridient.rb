class RecipeIngridient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingridient
end