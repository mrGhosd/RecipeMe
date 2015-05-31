class RecipeMe.Models.User extends Backbone.Model
  fileAttribute: 'avatar'

  initialize: (options) ->
    @params = options

  url: ->
    if @params && @params.id
      return "/api/users/#{@params.id}"
    else
      return "/api/users"

  parse: (response) ->
    if response.followers_list
      response.followers_list = new RecipeMe.Collections.Users(response.followers_list)
      response.followers_list.url = "api/users/#{response.id}/followers"
      response.followers_list.fetch({async: false})

    if response.following_list
      response.following_list = new RecipeMe.Collections.Users(response.following_list)
      response.following_list.url = "api/users/#{response.id}/following"
      response.following_list.fetch({async: false})
    return response

  isAdmin: ->
    return this.get("role") == "admin"

  isResourceOwner: (resource) ->
    if resource.get("user_id") == this.get("id")
      return true
    else
      return false
