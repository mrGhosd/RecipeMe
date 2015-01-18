class RecipeMe.Views.UserProfile extends Backbone.View
  template: JST['users/profile']
  'events':
    'click .edit-profile': 'showModalEdit'

  initialize: ->
    this.render()

  render: ->
    $(@el).html(@template(user: @user))
    this


  showModalEdit: ->
    modal = new RecipeMe.Views.CommonModal()
    $("#myModal").html(modal.el).modal('show')
    view = new RecipeMe.Views.EditProfile()
    modal.render()
    $("#myModal .modal-title").html("<h3>Редактировать пользователя</h3>")
    $("#myModal .modal-body").html(view.el)
    view.render()

