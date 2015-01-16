class RecipeMe.Views.Comment extends Backbone.View

  template: JST['comments/comment']
  tagName: 'div'
  className: 'comment'
  tagClass: 'recipe-comment'
  events:
    'click .edit-comment': 'editComment'
    'click .remove-comment': 'deleteComment'

  initialize: ->
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

  render: ->
    $(@el).html(@template(comment: @model))
    this