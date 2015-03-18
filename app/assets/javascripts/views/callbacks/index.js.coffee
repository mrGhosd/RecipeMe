class RecipeMe.Views.CallbackIndex extends Backbone.View
  template: JST["callbacks/index"]
  events:
    'click .add-callback': 'newCallback'

  initialize: ->
    @collection = new RecipeMe.Collections.Callbacks()
    @collection.fetch({async: false})
    @collection.on('add', @render, this)
    @collection.on('remove', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@addCallback)
    this


  addCallback: (callback) ->
    view = new RecipeMe.Views.Callback({model: callback})
    $(".callbacks-list").prepend(view.render().el)

  newCallback: ->
    if $(".callback-form").find("form").length
      $(".callback-form").find("form").remove()
    else
      view = new RecipeMe.Views.CallbackForm(collection: @collection)
      $(".callback-form").append(view.render().el)