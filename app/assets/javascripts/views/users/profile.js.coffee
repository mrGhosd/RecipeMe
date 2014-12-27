class RecipeMe.Views.UserProfile extends Backbone.View
  template: JST['users/profile']

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template(user: @user))
    this