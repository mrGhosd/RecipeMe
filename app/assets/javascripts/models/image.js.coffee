class RecipeMe.Models.Image extends Backbone.Model

  initialize: (options = {}) ->
    @image = this
    @step_id = options.step_id if options.step_id

  url: ->
    return "/api/images"

  setImageData:(response, klass ) ->
    json = JSON.parse(response)
    klass.set({image_id: json.id})

  uploadImage: (data)->
    this.makeRequest(data, this.setImageData, this)

  makeRequest: (data, callback, parent) ->
    request = new XMLHttpRequest();
    request.callback = callback
    request.onloadend = (response, request)->
      this.callback(this.response, parent)
    request.open("POST", "/api/images");
    request.send(data);