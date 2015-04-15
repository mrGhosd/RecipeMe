class RecipeMe.Views.LoginView extends Backbone.View

  template: JST['shared/login']
  events:
    'click .omniauth-links>a': 'omniauthLogin'

  initialize: ->
    this.render()

  omniauthLogin: (event) ->
    event.preventDefault()
    link = $(event.target)
    alert "1"
    console.log link
#    if link.attr("require-email") != undefined
#      modal = new RecipeMe.Views.CommonModal()
#      emailView = new RecipeMe.Views.AdditionalEmail({url: link.attr("href")})
#      $("#myModal").html($(modal.render().el).modal('show'))
#      $("#common-modal").removeClass("modal-lg")
#      $("#common-modal .modal-body").html(emailView.render().el)
#      $("#common-modal").modal('show')
#    else
#      window.location.href = link.attr("href")

  render: ->
    $(@el).html(@template())
    this