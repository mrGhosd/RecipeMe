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
    email = $(".additional-email").val()
    window.location.assign(@url+"?email=#{email}")


  render: ->
    $(@el).html(@template())
    this