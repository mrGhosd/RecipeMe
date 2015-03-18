class RecipeMe.LikedUsers
  constructor: (object) ->
    @object = object
    @entity = this.defineEntity()

  loadUsers: ->
    users_url = this.url(@entity)
    users = new RecipeMe.Collections.Users({usersURL: users_url})
    users.fetch({async: false})
    users.each(@addUsersToPopup)


  addUsersToPopup: (user) ->
    view = new RecipeMe.Views.LikedView({user: user})
    $(".popup-view").append(view.render().el)

  defineEntity: ->
    if @object instanceof RecipeMe.Models.Recipe
      return "recipe"
    else if @object instanceof RecipeMe.Models.Comment
      return "comment"
    else if @object instanceof RecipeMe.Models.New
      return "news"

  showUsersPopup: ->
    popup = $("<div class='popup-view'></div>")
    $(event.target).after(popup.hide().fadeIn())
    this.loadUsers()

  url: (entity) ->
    if entity == "recipe"
      return "api/recipes/#{@object.get("id")}/liked_users"
    else if entity == "comment"
      return "api/recipes/#{@object.get("recipe_id")}/comments/#{@object.get("id")}/liked_users"
    else if entity == "news"
      return "api/news/#{@object.get("id")}/liked_users"