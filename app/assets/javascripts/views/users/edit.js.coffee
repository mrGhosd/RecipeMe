class RecipeMe.Views.EditProfile extends Backbone.View
  template: JST['users/form']
  events:
    'submit #user_form': 'updateUserInfo'
    'change .user-avatar': 'acceptUserAvatar'

  initialize: ->
    @reader = new FileReader()
    this.render()

  render: ->
    $(@el).html(@template(user: @user))
    this

  acceptUserAvatar: ->
    $("#user_form .user-avatar").val()
    if $("#user_form .user-avatar").val() == "" || typeof $("#user_form .user-avatar").val() == "undefined"
      return false
    else
      $(".avatar-placeholder .image-view").remove()
      @reader.onload = (event) ->
        dataUri = event.target.result
        img = new Image(200, 200)
        img.class = "image-view"
        img.src = dataUri
        $(".avatar-placeholder").html(img)
      @reader.onerror = (event) ->
        console.log "ОШИБКА!"
      image = $("#user_form .user-avatar")[0].files[0]
      @reader.readAsDataURL(image)