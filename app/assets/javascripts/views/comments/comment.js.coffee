class RecipeMe.Views.Comment extends Backbone.View

  template: JST['comments/comment']
  tagName: 'div'
  className: 'comment'
  tagClass: 'recipe-comment'
  events:
    'click .edit-comment': 'editComment'
    'click .remove-comment': 'deleteComment'
    'click .comment-rate-action': 'changeRate'
    'mouseover .comment-rate-value': 'showVotedUsersPopup'
    'mouseleave .comment-rate-value': 'hideVotedUsersPopup'

  initialize: (params)->
    if params.model
      @model = params.model
    this.render()

  editComment: (event)->
    event.preventDefault()
    if $(".row.comment-form").length > 0
      $(".row.comment-form").parent().prev("div").show()
      $(".row.comment-form").parent().remove()
    options = {recipe: null, comment: null}
    button = $(event.currentTarget)
    comment = button.data("comment")
    recipe = button.data("recipe")
    comment_block = button.closest(".comment")
    comment_text = $(comment).find(".comment-text").text()
    recipeModel = new RecipeMe.Models.Recipe(id: recipe)
    recipeModel.fetch
      async: false
      success: (model)->
        options.recipe = model

    commentModel = new RecipeMe.Models.Comment({recipe: recipeModel.get('id'), id: comment})
    commentModel.fetch
      async: false
      success: (model) ->
        options.comment = model

    view = new RecipeMe.Views.CommentForm({model: options})
    comment_block.hide()
    comment_block.after view.render().el

  changeRate: (event) ->
    new RecipeMe.Rate(@model).changeRate(
      success = (response, request) ->
        $(event.target).next("a.comment-rate-value").text(response.rate)
    )

  deleteComment: (event)->
    button = $(event.currentTarget)
    comment = button.data("comment")
    recipe = button.data("recipe")
    commentModel = new RecipeMe.Models.Comment({recipe: recipe, id: comment})
    commentModel.fetch({async: false})
    commentModel.destroy
      success: (response, request)->
        console.log response
        console.log request
      error: (response, request)->
        console.log response
        console.log request
    comment = button.closest(".comment")
    comment.fadeOut('slow')

  showVotedUsersPopup: (event) ->
    if RecipeMe.currentUser || $(".popup-view")
      new RecipeMe.LikedUsers(@model).showUsersPopup()
    else
      return false

  hideVotedUsersPopup: (event) ->
    $(".popup-view").remove()
    $(".popup-view").fadeOut()

  render: ->
    $(@el).html(@template(comment: @model))
    this