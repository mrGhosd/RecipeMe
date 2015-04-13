class RecipeMe.Views.UserProfile extends Backbone.View
  template: JST['users/profile']
  'events':
    'click .edit-profile': 'showModalEdit'
    'click .toggle-user-recipes': 'toggleUserRecipes'
    'click .add-following': 'createFollowing'
    'click .remove-following': 'deleteFollowing'

  initialize: (params)->
    @params = params
    this.render()

  render: ->
    $(@el).html(@template({user: @params.user}))
    this

  toggleUserRecipes: (event)->
    button = $(event.target)
    if button.hasClass("glyphicon-arrow-up")
      $(".user-recipes-body").html("")
      button.removeClass("glyphicon-arrow-up").addClass("glyphicon-arrow-down")
    else
      collection = new RecipeMe.Collections.Recipes({url: "api/users/#{@params.user.get("id")}/recipes"})
      collection.fetch({async: false})
      recipes = collection.slice(0,20)
      for recipe in recipes
        this.showProfileRecipe(recipe)
      button.removeClass("glyphicon-arrow-down").addClass("glyphicon-arrow-up")


  showProfileRecipe: (recipe) ->
    view = new RecipeMe.Views.ProfileRecipe({model: recipe})
    $(".user-recipes-body").append(view.render().el)

  showModalEdit: ->
    modal = new RecipeMe.Views.CommonModal()
    $("#myModal").html(modal.el).modal('show')
    view = new RecipeMe.Views.EditProfile({user: @params.user})
    modal.render()
    $("#myModal .modal-title").html("<h3>#{I18n.t('user.edit_profile')}</h3>")
    $("#myModal .modal-body").html(view.el)
    view.render()

  createFollowing: (event) ->
    $.ajax "/api/relationships",
      type: "POST"
      data: { id: @params.user.get("id") }
      success: (response, request) ->
        $(event.target).text("#{I18n.t('user.unfollow')}")
                       .removeClass("add-following")
                       .addClass("remove-following")
        Backbone.trigger("navigationMenu", response)
      error: (response, request) ->
        console.log response
        console.log request



  deleteFollowing: (event) ->
    $.ajax "/api/relationships/#{@params.user.get("id")}",
      type: "DELETE"
      success: (response, request) ->
        $(event.target).text("Подписаться")
                       .removeClass("remove-following")
                       .addClass("add-following")
        Backbone.trigger("navigationMenu", response)
      error: (response, request) ->
        console.log response
        console.log request

