class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']
  events:
    'click a': 'hideNavigationMenu'

  initialize:(options = {}) ->
    @view = options.view if options.view

    this.render()

  hideNavigationMenu: (e)->
    @view.toggleLeftMenu(false)

  render: ->
    $(@el).html(@template())
    this



