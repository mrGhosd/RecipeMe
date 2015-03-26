class RecipeMe.Views.RecipeShow extends Backbone.View

  template: JST['recipes/show']

  events:
    'click .back-button': 'returnToList'
    'click .add-comment-button': 'showCommentForm'
    'click .rate-icon': 'changeRate'
    'mouseover .rate-value': 'showVotedUsersPopup'
    'mouseleave .rate-value': 'hideVotedUsersPopup'

  initialize: (params) ->
    if params
      @model = params.model
      @steps = @model.get("steps")
      @comments = @model.get('comments')
      @ingridients = @model.get('ingridients')
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

  changeRate: ->
    if RecipeMe.currentUser
      new RecipeMe.Rate(@model).changeRate(
        success = (response, request) ->
          $(".rate-value").text(response.rate)
      )
    else
      return false

  render: ->
    $(@el).html(@template(recipe: @model))
    @steps.each(@addStep)
    @comments.each(@addComment)
    @ingridients.each(@addIngridient)
    this

  showVotedUsersPopup: (event) ->
    if RecipeMe.currentUser || $(".popup-view")
      new RecipeMe.LikedUsers(@model).showUsersPopup()
    else
      return false

  hideVotedUsersPopup: (event) ->
    $(".popup-view").remove()
    $(".popup-view").fadeOut()


  addStep: (step) ->
    view = new RecipeMe.Views.Step({model: step})
    $(".steps-line").append view.render().el

  addComment: (comment)->
    if !_.isEqual(comment.attributes, {recipe: comment.get("recipe")})
      view = new RecipeMe.Views.Comment({model: comment})
      $(".recipe-comments").prepend view.render().el

  addIngridient: (ingridient) ->
    view = new RecipeMe.Views.Ingridient({model: ingridient})
    $(".ingiridents-list").append(view.render().el)


  showComments: (comment)->
    view = new RecipeMe.Views.Comment({model: comment})
    $(".recipe-comments").prepend view.render().el
