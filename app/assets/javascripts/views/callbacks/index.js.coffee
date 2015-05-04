class RecipeMe.Views.CallbackIndex extends Backbone.View
  template: JST["callbacks/index"]
  events:
    'click .add-callback': 'newCallback'

  initialize: ->
    @collection = new RecipeMe.Collections.Callbacks()
    @collection.fetch({async: false})
    @collection.on('change', @render, this)
    @collection.on('add', @render, this)
    @collection.on('remove', @render, this)
    @collection.on('reset', @render, this)
    @listenTo(Backbone, "Callback", @updateCallback)

  updateCallback: (data) ->
    @model = @collection.get(data.id)
    if data.action == "create"
      @collection.add(data.obj)
    if data.action == "destroy"
      @collection.remove(@model)
    if data.action == "update"
      @model.set(data.obj)


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
      view = new RecipeMe.Views.CallbackForm({collection: @collection})
      $(".callback-form").append(view.render().el)