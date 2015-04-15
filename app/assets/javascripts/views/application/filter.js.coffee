class RecipeMe.Views.Filter extends Backbone.View
  template: JST["application/filter"]

  initialize: (params) ->
    if params
      console.log params
      @objects = params.objects
      @filterData = params.filterData

  addObject: (object) ->
    recipe = new RecipeMe.Models.Recipe(object)
    view = new RecipeMe.Views.Recipe(model: recipe)
    $("ul.filter-list").append(view.render().el)

  render: ->
    $(@el).html(@template(filter: @filterData))
    this.addObject(obj) for obj in @objects
    this