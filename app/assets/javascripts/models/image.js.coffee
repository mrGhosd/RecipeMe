class RecipeMe.Models.Image extends Backbone.Model

  initialize: (options = {}) ->
    @image = this
    @image_id = options.id if options.id

  url: ->
    if @image_id
      return "/api/images/#{@image_id}"
    else
      return "/api/images"

  lol:(response, klass ) ->
    json = JSON.parse(response)
    klass.set({image_id: json.id})


  uploadImage: (data)->
    this.makeRequest(data, this.lol, this)

  makeRequest: (data, callback, parent) ->
    request = new XMLHttpRequest();
    request.callback = callback
    request.onloadend = (response, request)->
      this.callback(this.response, parent)
    request.open("POST", "/api/images");
    request.send(data);