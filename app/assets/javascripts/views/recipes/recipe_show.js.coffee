class RecipeMe.Views.RecipeShow extends Backbone.View

  template: JST['recipes/show']

  events:
    'click .back-button': 'returnToList'
    'click .add-comment-button': 'showCommentForm'

  initialize: ->
    this.render()

  showCommentForm: ->
    console.log @model
    options = {recipe: @model}
    view = new RecipeMe.Views.CommentForm(model: options)
    $(".comment-form").html(view.el)
    view.render()

  returnToList: (event)->
    Backbone.history.navigate('/recipes', {trigger: true, repalce: true})

  render: ->
    $(@el).html(@template(recipe: @model))
    if @model.get('comments').length > 0
      comments = @model.get('comments')
      for comment in comments
        bb_comment = new RecipeMe.Models.Comment({recipe: @model})
        bb_comment.set(comment)
        @showComments(bb_comment)

    this

  showComments: (comment)->
    view = new RecipeMe.Views.Comment({model: comment})
    $(".recipe-comments").append view.render().el
