class RecipeMe.Models.User extends Backbone.Model
#  urlRoot: '/api/users'
  fileAttribute: 'avatar'

  initialize: (options) ->
    @params = options

  url: ->
    if @params.id
      return "/api/users/#{@params.id}"
    else
      return "/api/users"

  parse: (response) ->
    if response.followers
      response.followers = new RecipeMe.Collections.Users(response.followers)
    if response.following
      response.following = new RecipeMe.Collections.Users(response.following)
    return response
