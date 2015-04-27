class RecipeMe.Views.MainContentView extends Backbone.View

  events:
    'click a': 'navigate'

  initialize: ->
#    @listenTo(Backbone, "Auth", @updateView)


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

