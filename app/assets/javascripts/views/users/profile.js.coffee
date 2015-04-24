class RecipeMe.Views.UserProfile extends Backbone.View
  template: JST['users/profile']
  'events':
    'click .edit-profile': 'showModalEdit'
    'click .toggle-user-recipes': 'toggleUserRecipes'
    'click .add-following': 'createFollowing'
    'click .remove-following': 'deleteFollowing'
    'click .toggle-user-comments': 'toggleuserComments'

  initialize: (params)->
    @params = params
    @listenTo(Backbone, "User", @updateUser)
    this.render()


  updateUser: (data) ->
    if parseInt(@params.user.get("id"), 10) == parseInt(data.id, 10)
      if data.action == "follow"
        current_count = parseInt($(".followers-count").text(), 10)
        $(".followers-list-link").find(".followers-count").text("#{current_count + 1}")
      if data.action == "following"
        current_count = parseInt($(".following-count").text(), 10)
        $(".following-list-link").find(".following-count").text("#{current_count + 1}")
      if data.action == "unfollowing"
        current_count = parseInt($(".following-count").text(), 10)
        $(".following-list-link").find(".following-count").text("#{current_count - 1}")
      if data.action == "unfollow"
        current_count = parseInt($(".followers-count").text(), 10)
        $(".followers-list-link").find(".followers-count").text("#{current_count - 1}")


  render: ->
    $(@el).html(@template({user: @params.user}))
    this

  toggleUserRecipes: (event)->
    button = $(event.target)
    if button.hasClass("glyphicon-arrow-up")
      $(".user-recipes-body").html("")
      button.removeClass("glyphicon-arrow-up").addClass("glyphicon-arrow-down")
    else
      this.recipesCollection()
      button.removeClass("glyphicon-arrow-down").addClass("glyphicon-arrow-up")

  toggleuserComments: (event) ->
    button = $(event.target)
    if button.hasClass("glyphicon-arrow-up")
      $(".user-comments-body").html("")
      button.removeClass("glyphicon-arrow-up").addClass("glyphicon-arrow-down")
    else
      this.commentsCollection()
      button.removeClass("glyphicon-arrow-down").addClass("glyphicon-arrow-up")


  showProfileRecipe: (recipe) ->
    view = new RecipeMe.Views.ProfileRecipe({model: recipe})
    $(".user-recipes-body").append(view.render().el)

  showProfileComment: (comment) ->
    view = new RecipeMe.Views.ProfileComment({model: comment})
    $(".user-comments-body").append(view.render().el)

  showModalEdit: ->
    modal = new RecipeMe.Views.CommonModal()
    $("#myModal").html(modal.el).modal('show')
    view = new RecipeMe.Views.EditProfile({user: @params.user})
    modal.render()
    $("#myModal .modal-title").html("<h3>#{I18n.t('user.edit_profile')}</h3>")
    $("#myModal .modal-body").html(view.el)
    view.render()

  commentsCollection: ->
    collection = new RecipeMe.Collections.Comments({url: "api/users/#{@params.user.get("id")}/comments"})

    collection.fetch({async: false})
    comments = collection.slice(0,10)
    for comment in comments
      this.showProfileComment(comment)

  recipesCollection: ->
    collection = new RecipeMe.Collections.Recipes({url: "api/users/#{@params.user.get("id")}/recipes"})
    collection.fetch({async: false})
    recipes = collection.slice(0,20)
    for recipe in recipes
      this.showProfileRecipe(recipe)

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

