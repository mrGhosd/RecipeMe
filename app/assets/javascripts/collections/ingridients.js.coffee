class RecipeMe.Collections.Ingridients extends Backbone.Collection
  model: RecipeMe.Models.Ingridient
  url: '/api/ingridients'

  search: (letters) ->
    return null if letters == " "

    pattern = new RegExp(letters,"gi")
    this.filter (data) ->
      return pattern.test(data.get("name"))
