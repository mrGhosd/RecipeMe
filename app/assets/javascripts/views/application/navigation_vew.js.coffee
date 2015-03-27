class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']
  events:
    'click a': 'hideNavigationMenu'

  initialize:(options = {}) ->
    @view = options.view if options.view
    if RecipeMe.currentUser
      @user = RecipeMe.currentUser
      @user.fetch({async: false})

    this.render()

  hideNavigationMenu: (e)->
    @view.toggleLeftMenu(false)

  render: ->
    $(@el).html(@template(user: @user))
    this



