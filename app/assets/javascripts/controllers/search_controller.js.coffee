class RecipeMe.SearchController
  constructor: (text, type) ->
    @objects = []
    @filterData = text
    @filterType = type

  search: (callback, param)->
    $.ajax "/api/search/#{@filterData}",
      type: "GET"
      data: {filter: @filterType}
      success: (response, request) ->
        @objects = response
        callback(response, param)
      error: (response, request) ->
        console.log response
        console.log request

  filterByTag: (objects, filterData)->
    view = new RecipeMe.Views.Filter({objects: objects, filterData: filterData})
    $("section#main").html(view.el)
    view.render()