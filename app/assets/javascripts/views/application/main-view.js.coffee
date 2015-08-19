class RecipeMe.Views.ApplicationView extends Backbone.View
  template: JST['application/main']

  initialize: ->
    this.render()
    this.initAppLayout()


  initAppLayout: ->
    header = new RecipeMe.Views.HeaderView({el: 'div.app-header'})
    new RecipeMe.Views.NavigationView({el: '#navigationMenu', view: header}  )
    new RecipeMe.Views.FooterView({el: 'footer.footer'})

  render: ->
    $(@el).html(@template())
    this

  updateView:->
    this.initAppLayout()
    this.render()

  navigate: (event)->
    event.preventDefault();
    Backbone.history.navigate(event.target.pathname, {trigger: true})




