class RecipeMe.Views.NavigationView extends Backbone.View

  template: JST['application/navigation']
  events:
    'click a': 'hideNavigationMenu'

  initialize:(options = {}) ->
    @view = options.view if options.view
    @user = RecipeMe.currentUser
    @user.fetch({async: false})

    this.render()

  hideNavigationMenu: (e)->
    @view.toggleLeftMenu(false)

  render: ->
    console.log @user
    $(@el).html(@template(user: @user))
    this



