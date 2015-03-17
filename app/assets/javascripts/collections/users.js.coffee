class RecipeMe.Collections.Users extends Backbone.Collection
  model: RecipeMe.Models.User

  initialize: (params) ->
    if params.usersURL
      this.url = params.usersURL
    else
      this.url = "api/users"