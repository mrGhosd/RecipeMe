class RecipeMe.Views.ApplicationView extends Backbone.View
  template: JST['application/main']

  events:
    'click a': 'navigate'

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

  navigate: (event) ->
    event.preventDefault()
    event.stopPropagation()
    if $(event.currentTarget).data("remote") != "true" && $(event.currentTarget).attr("href") != "#"
      Backbone.history.navigate($(event.currentTarget).attr("href"), {trigger: true})
#    console.log $(event.currentTarget).attr("href").length




