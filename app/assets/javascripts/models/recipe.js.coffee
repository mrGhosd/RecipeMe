class RecipeMe.Models.Recipe extends Backbone.Model
  urlRoot: '/api/recipes'
  fileAttribute: 'image'

  parse: (response) ->
    if response.comments
      response.comments = new RecipeMe.Collections.Comments({recipe: response.id})
      response.comments.fetch()
    if response.steps
      response.steps = new RecipeMe.Collections.Steps({recipe: response.id})
      response.steps.fetch()
    return response

  setFile: (file) ->
    setFromFile = (file) ->
    reader = new FileReader()
    self = this
    reader.onload = ((f) ->
      (e) ->
        self.set image: e.target.result
        return
    )(file)
    reader.readAsDataURL(file)
    return
