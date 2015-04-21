class RecipeMe.Views.RecipeShow extends Backbone.View

  template: JST['recipes/show']

  events:
    'click .back-button': 'returnToList'
    'click .add-comment-button': 'showCommentForm'
    'click .rate-icon': 'changeRate'
    'click .tag-data': 'searchRecipesByTag'
    'click .ingridient-link': 'searchRecipeByIngridient'

  initialize: (params) ->
    @page = 1
    @listenTo(Backbone, "Recipe", @updateData)
    if params
      @model = params.model
      @steps = @model.get("steps")
      @comments = @model.get('comments')
      @ingridients = @model.get('ingridients')
      @comments.on('add', @render, this)
      @comments.on('remove', @render, this)
      @comments.on('reset', @render, this)
    this.render()


  updateData: (data) ->
    if data.action == "rate"
      @model.set({rate: data.obj.rate})
      this.render()
    if data.action == "attributes-change"
      @model.set(data.obj)
      this.render()
    if data.action == "image"
      @model.set({image: data.image})
      this.render()
    if data.action == "comment-create"
      model = new RecipeMe.Models.Comment(data.obj)
      @comments.add(model)
    if data.action == "comment-destroy"
      model = new RecipeMe.Models.Comment(data.obj)
      @comments.remove(model)



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

  searchRecipesByTag: (event) ->
    text = $(event.target).text()
    Backbone.history.navigate("/search/tag/#{text}", {trigger: true, repalce: true})

  searchRecipeByIngridient: (event) ->
    text = $(event.target).closest("a.ingridient-link").find("span.name").text()
    Backbone.history.navigate("/search/ingridient/#{text}", {trigger: true, repalce: true})

  render: ->
    $(@el).html(@template(recipe: @model))
    @steps.each(@addStep)
    @comments.each(@addComment)
    @ingridients.each(@addIngridient)
    window.scrollUpload.init(@page, "api/recipes/#{@model.get('id')}/comments", $("div.recipe-comments"), this.successCommentsUpload)
    this

  successCommentsUpload: (response, request) ->
    for model in response
      comment = new RecipeMe.Models.Comment(model)
      view = new RecipeMe.Views.Comment(model: comment)
      $("div.recipe-comments").append(view.render().el)

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
