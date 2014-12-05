class RecipeMe.Views.ApplicationView extends Backbone.View
  template: JST['application/main']

  initialize: ->
    this.render()

    new RecipeMe.Views.HeaderView({el: 'header'})
    new RecipeMe.Views.NavigationView({el: 'nav'})
    new RecipeMe.Views.FooterView({el: 'footer'})
  render: ->
    $(@el).html(@template())
    this