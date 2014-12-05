class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']

  events:
    'click a': 'navigate'

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template())
    this

  navigate: (event)->
    event.preventDefault();
    Backbone.history.navigate(event.target.pathname, {trigger: true})

