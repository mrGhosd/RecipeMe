class RecipeMe.Models.Recipe extends Backbone.Model
  urlRoot: '/api/recipes'
  fileAttribute: 'image'

  initialize: (params = {}) ->
    if !params
      this.set("image", new RecipeMe.Models.Image())

  parse: (response) ->
    if response.comments_list
      response.comments = new RecipeMe.Collections.Comments(response.comments_list)
      response.comments.recipe = response.id
#      response.comments.fetch({async: false})
#      console.log response.comments
    if response.steps_list
      response.steps = new RecipeMe.Collections.Steps(response.steps_list)
      response.steps.recipe = response.id
      console.log response.steps
    if response.ingridients_list
      response.ingridients = new RecipeMe.Collections.Ingridients(response.ingridients_list)
      response.ingridients.recipe = response.id
#      response.ingridients.fetch({async: false})
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

