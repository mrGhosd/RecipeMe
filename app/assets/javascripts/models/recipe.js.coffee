class RecipeMe.Models.Recipe extends Backbone.Model
  urlRoot: '/api/recipes'
  fileAttribute: 'image'

  parse: (response) ->
    if response.comments
      response.comments = new RecipeMe.Collections.Comments({recipe: response.id})
      response.comments.fetch({async: false})
    if response.steps
      response.steps = new RecipeMe.Collections.Steps({recipe: response.id})
      response.steps.fetch({async: false})
    if response.ingridients
      console.log response
      response.ingridients = new RecipeMe.Collections.Ingridients({recipe: response.id})
      response.ingridients.fetch({async: false})
    return response


  checkoutRate: ->



  createFromForm: (recipe, steps, ingridients, successCallback, errorCallback) ->
    this.save(recipe,
      success: (response, request)->
        steps.callback(steps.steps, response, request)
        ingridients.callback(ingridients.ingridients, response, request)
        successCallback(response, request)
      error: (response, request) ->
        errorCallback(response, request)
    )

