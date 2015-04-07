class RecipeMe.Collections.Feeds extends Backbone.Collection
  model: RecipeMe.Models.Feed

  initialize: (options)->
    if options != null
      @user = options.user

  url: (option) ->
    if option != null
      return "api/users/#{@user}/feed"


