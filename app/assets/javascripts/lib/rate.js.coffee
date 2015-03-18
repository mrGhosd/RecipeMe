class RecipeMe.Rate
  constructor: (object) ->
    @object = object
    @id = object.get("id")
    @entity = this.defineEntity(object)

  changeRate:(callback) ->
    this.performRequest(@entity, @id, @object, callback)

  performRequest: (entity, id, object, callback)->
    $.ajax this.url(@object),
      type: "POST"
      data: {id: object.get("id")}
      callback: callback
      success: (response, request) ->
        this.callback(response, request)

  defineEntity: (object) ->
    if object instanceof RecipeMe.Models.Recipe
      return "recipes"
    else if object instanceof RecipeMe.Models.Comment
      return "comments"
    else if object instanceof RecipeMe.Models.New
      return "news"

  url: (entity) ->
    if entity instanceof RecipeMe.Models.Recipe || entity instanceof RecipeMe.Models.New
      return "/api/#{@entity}/#{@id}/rating"
    else if entity instanceof RecipeMe.Models.Comment
      return "/api/recipes/#{entity.get("recipe_id")}/#{@entity}/#{@id}/rating"