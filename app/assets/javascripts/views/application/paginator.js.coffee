#class RecipeMe.Views.Paginator extends Backbone.Views
#  className: 'pagination pagination-centered'
#
#  initialize: ->
#    @model.bind "reset", @render, this
#    @render()
#    return
#
#  render: ->
#    items = @model.models
#    len = items.length
#    pageCount = Math.ceil(len / 8)
#    $(@el).html "<ul />"
#    i = 0
#
#    while i < pageCount
#      $("ul", @el).append "<li" + ((if (i + 1) is @options.page then " class='active'" else "")) + "><a href='#recipes/page/" + (i + 1) + "'>" + (i + 1) + "</a></li>"
#      i++
#    this