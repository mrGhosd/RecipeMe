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

  initialize: ->
    if this.get('comments') != null
      this.comments = new RecipeMe.Collections.Comments(recipe: this.id)
      this.comments.fetch parse: true

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
