class RecipeMe.Views.RecipeShow extends Backbone.View

  template: JST['recipes/show']

  events:
    'click .back-button': 'returnToList'
    'click .add-comment-button': 'showCommentForm'

  initialize: ->
    @comments = @model.get('comments')
    @comments.on('add', @render, this)
    @comments.on('reset', @render, this)
    this.render()

  showCommentForm: ->
    options = {recipe: @model}
    view = new RecipeMe.Views.CommentForm(model: options)
    $(".comment-form").html(view.el)
    view.render()

  returnToList: (event)->
    Backbone.history.navigate('/recipes', {trigger: true, repalce: true})

  render: ->
    $(@el).html(@template(recipe: @model))
    console.log @comments.length
    @comments.each(@addComment) if @comments.length > 1
    this


  addComment: (comment)->
    view = new RecipeMe.Views.Comment({model: comment})
    $(".recipe-comments").prepend view.render().el


  showComments: (comment)->
    view = new RecipeMe.Views.Comment({model: comment})
    $(".recipe-comments").prepend view.render().el
