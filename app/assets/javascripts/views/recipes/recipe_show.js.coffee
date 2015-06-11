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
    @listenTo(Backbone, "Recipe", @updateRecipe)
    @listenTo(Backbone, "Step", @updateStep)
    @listenTo(Backbone, "Ingridient", @updateIngridient)
    if params
      @model = params.model
      @steps = @model.get("steps")
      @comments = @model.get('comments')
      @ingridients = @model.get('ingridients')

      @steps.on('add', @render, this)
      @steps.on('change', @render, this)
      @steps.on('remove', @render, this)

      @ingridients.on('add', @render, this)
      @ingridients.on('remove', @render, this)

#      @comments.on('push', @renderCommentList, this)
      @comments.on('add', @render, this)

      @comments.on('change', @render, this)
      @comments.on('remove', @render, this)
    this.render()


  updateRecipe: (data) ->
    if parseInt(@model.get("id"), 10) == parseInt(data.id, 10)
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
      if data.action == "comment-update"
        model = @comments.get(data.obj.id)
        model.set({text: data.obj.text})
      if data.action == "comment-destroy"
        model = new RecipeMe.Models.Comment(data.obj)
        @comments.remove(model)

  updateIngridient: (data) ->
    if parseInt(@model.get("id"), 10) == parseInt(data.id, 10)
      @ingridient = @ingridients.get(data.obj.id)
      if data.action == "create"
        data.obj["size"] = data.size
        @ingridient = new RecipeMe.Models.Ingridient(data.obj)
        @ingridients.add(@ingridient)
      if data.action == "destroy"
        @ingridient = @ingridients.get(data.obj.id)
        @ingridients.remove(@ingridient)
      if data.action == "update"
        @ingridient.set(data.obj)

  updateStep: (data) ->
    if parseInt(@model.get("id"), 10) == parseInt(data.id, 10)
      @step = @steps.get(data.obj.id)
      if data.action == "create"
        @step = new RecipeMe.Models.Step(data.obj)
        @steps.add(@step)
      if data.action == "destroy"
        @step = new RecipeMe.Models.Step(data.obj)
        @steps.remove(@step)
      if data.action == "update"
        @step.set(data.obj)
      if data.action == "image"
        @step = @steps.get(data.obj.id)
        @step.set({image: data.image})
        this.render()


  showCommentForm: ->
    options = {recipe: @model, collection: @comments}
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
    window.scrollUpload.init(@page, "api/recipes/#{@model.get('id')}/comments", $("div.recipe-comments"), this.successCommentsUpload, @comments)
    this

  successCommentsUpload: (response, request, collection) ->
    for model in response
      collection.add(model)

  showVotedUsersPopup: (event) ->
    if RecipeMe.currentUser || $(".popup-view")
      new RecipeMe.LikedUsers(@model).showUsersPopup()
    else
      return false

  hideVotedUsersPopup: (event) ->
    $(".popup-view").remove()
    $(".popup-view").fadeOut()

  renderCommentList: (comment) ->
    alert "1"

  addStep: (step) ->
    view = new RecipeMe.Views.Step({model: step})
    $(".steps-line").append view.render().el

  addComment: (comment)->
    if !_.isEqual(comment.attributes, {recipe: comment.get("recipe")})
      view = new RecipeMe.Views.Comment({model: comment})
      $(".recipe-comments").append view.render().el

  addIngridient: (ingridient) ->
    view = new RecipeMe.Views.Ingridient({model: ingridient})
    $(".ingiridents-list").append(view.render().el)

  showComments: (comment)->
    view = new RecipeMe.Views.Comment({model: comment})
    $(".recipe-comments").prepend view.render().el
