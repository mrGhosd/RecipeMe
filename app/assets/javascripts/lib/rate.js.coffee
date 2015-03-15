class RecipeMe.Rate
  constructor: (object) ->
    @object = object
    @id = object.get("id")
    @entity = this.defineEntity(object)

  changeRate:(callback) ->
    this.performRequest(@entity, @id, @object, callback)

  performRequest: (entity, id, object, callback)->
    $.ajax "/api/#{entity}/#{id}/rating",
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