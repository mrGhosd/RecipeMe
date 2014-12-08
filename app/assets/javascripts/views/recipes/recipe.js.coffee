class RecipeMe.Views.Recipe extends Backbone.View

  template: JST['recipes/recipe']
  tagName: 'li'
  tagClass: 'col-md-4'

  initialize: ->
    this.render()
    $("#g1").jFlip(300,300,{background:"green",cornersTop:false}).
    bind "flip.jflip", (event,index,total) ->
      $("#l1").html("Image "+(index+1)+" of "+total)

  render: ->
    $(@el).html(@template(recipe: @model))
    this