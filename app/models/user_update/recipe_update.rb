class RecipeUpdate < UserUpdate
  def entity
    recipe = Recipe.find(self.update_id)
    recipe.as_json(methods: [:image, :tag_list]) if recipe
  end

  def follower_user
    super
  end

  def as_json(*)
    super(methods: [:entity, :follower_user])
  end
end