class RecipeMe.Views.UserFollowers extends Backbone.View
  initialize: (params) ->
    if params.collection
      @collection = params.collection
