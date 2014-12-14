class RecipeMe.Models.Recipe extends Backbone.Model
  urlRoot: '/api/recipes'

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
