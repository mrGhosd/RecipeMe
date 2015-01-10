class RecipeMe.Models.Recipe extends Backbone.Model
  urlRoot: '/api/recipes'
  fileAttribute: 'image'
  paramRoot: 'recipe'

  defaults:
    title: ""
    description: ""
    user_id: ""
    comments:
      text: ""

  parse: (response) ->
    response.comments = new RecipeMe.Collections.Comments({recipe: response.id})
    response.comments.fetch()
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
