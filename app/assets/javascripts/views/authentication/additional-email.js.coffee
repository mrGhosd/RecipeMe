class RecipeMe.Views.AdditionalEmail extends Backbone.View
  template: JST['shared/additional-email']
  events:
    'submit .additional-emal': 'submitEmail'

  initialize:(params) ->
    @url = params.url if params.url
    this.render()

  submitEmail: (event) ->
    event.preventDefault()
    event.stopPropagation()
    window.location.href= @url+"?email=#{$(".additional-email").val()}"

  render: ->
    $(@el).html(@template())
    this