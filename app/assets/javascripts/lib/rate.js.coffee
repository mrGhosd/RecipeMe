class RecipeMe.Rate
  constructor: (object) ->
    @object = object
    @id = object.get("id")
    @entity = this.defineEntity(object)

  changeRate: ->
    this.performRequest(@entity, @id, this.successRequest(), @object)

  performRequest: (entity, id, callback, object)->
    data = {success: "true"}
    request = new XMLHttpRequest();
    request.callback = callback
    request.onloadend = (response, request)->
      this.callback(this.response, object)
    request.open("POST", "/api/#{entity}/#{id}/rate");
    request.send(data);

  successRequest: (response, object) ->
    console.log response
    console.log object

  defineEntity: (object) ->
    if object instanceof RecipeMe.Models.Recipe
      return "recipes"
    else if object instanceof RecipeMe.Models.Comment
      return "comments"