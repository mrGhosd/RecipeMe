class RecipeValidator < ActiveModel::Validator
  def validate(recipe)
    unless recipe.difficult.downcase.in? ["easy", "medium", "hard"]
      recipe.errors[:difficult] << t("recipes.errors.difficult")
    end
  end
end