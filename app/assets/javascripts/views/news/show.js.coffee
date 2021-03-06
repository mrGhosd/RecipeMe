class RecipeMe.Views.NewsShow extends Backbone.View
  template: JST["news/show"]
  className: "news-show"
  events:
    'click .rate-icon': 'changeRate'
    'mouseover .rate-value': 'showVotedUsersPopup'
    'mouseleave .rate-value': 'hideVotedUsersPopup'
    'click .back-button': 'returnToNewsList'

  initialize: (params) ->
    if params
      @news = params.model
      @listenTo(Backbone, "News", @updateNews)

  updateNews: (data) ->
    if parseInt(data.id, 10) == parseInt(@news.get("id"), 10)
      @model = @news
      if data.action == "update"
        @model.set(data.obj)
      if data.action == "rate"
        @model.set({rate: data.obj.rate})
      if data.action == "image"
        @model.set({image: data.image})
      this.render()


  changeRate: (event) ->
    if RecipeMe.currentUser
      new RecipeMe.Rate(@news).changeRate(
        success = (response, request) ->
          $(".rate-value").text(response.rate)
      )
    else
      return false

  showVotedUsersPopup: (event) ->
    if RecipeMe.currentUser || $(".popup-view")
      new RecipeMe.LikedUsers(@model).showUsersPopup()
    else
      return false

  hideVotedUsersPopup: (event) ->
    $(".popup-view").remove()
    $(".popup-view").fadeOut()

  returnToNewsList: (event)->
    event.preventDefault()
    Backbone.history.navigate('/news', {trigger: true, repalce: true})

  render: ->
    $(@el).html(@template(news: @news))
    this