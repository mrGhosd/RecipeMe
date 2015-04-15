class RecipeMe.SearchController
  constructor: (text, type) ->
    @objects = []
    @filterData = text
    @filterType = type

  search: (callback, param, viewFilterType)->
    $.ajax "/api/search/#{@filterData}",
      type: "GET"
      data: {filter: @filterType}
      success: (response, request) ->
        @objects = response
        callback(response, param, viewFilterType)
      error: (response, request) ->
        console.log response
        console.log request

  filterByTagOrIngridient: (objects, filterData, type)->
    view = new RecipeMe.Views.Filter({objects: objects, filterData: filterData, viewType: type})
    $("section#main").html(view.el)
    view.render()


  filterByIngridient: (objects, filterData, type) ->
    view = new RecipeMe.Views.Filter({objects: objects, filterData: filterData})
    $("section#main").html(view.el)
    view.render()