class RecipeMe.Views.Comment extends Backbone.View

  template: JST['comments/comment']
  tagName: 'div'
  tagClass: 'recipe-comment'
  events:
    'click .edit-comment': 'editComment'
    'click .remove-comment': 'deleteComment'

  initialize: ->
    this.render()

  editComment: (event)->
    button = $(event.currentTarget)
    comment = button.data("comment")
    recipe = button.data("recipe")
    comment_block = button.closest("div")
    comment_text = $(comment).find(".comment-text").text()
    recipeModel = new RecipeMe.Models.Recipe({id: recipe})
    recipeModel.fetch()
    commentModel = new RecipeMe.Models.Comment({recipe: recipeModel.get('id'), url: comment})
    commentModel.fetch()
    commentModel.set(text: comment_text)
    options = {recipe: recipeModel, comment: commentModel}
    view = new RecipeMe.Views.CommentForm({model: options})
    comment_block.hide()
    comment_block.after view.render().el

  deleteComment: (event)->
    button = $(event.currentTarget)
    comment = button.closest("div")
    comment.fadeOut('slow')

  render: ->
    $(@el).html(@template(comment: @model))
    this