class RecipeMe.Views.EditProfile extends Backbone.View
  template: JST['users/form']
  events:
    'submit #user_form': 'updateUserInfo'
    'change .user-avatar': 'acceptUserAvatar'

  initialize: (params)->
    @params = params
    console.log @params.user
    @reader = new FileReader()
    this.render()

  render: ->
    $(@el).html(@template(user: @params.user))
    this

  updateUserInfo: (event) ->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#user_form"))
    @params.user.unset("following_list")
    @params.user.unset("followers_list")
    @params.user.save(attributes,
      success: (response, request)->
        $("#myModal").modal('hide')
        RecipeMe.currentUser = response
        console.log response
        view = new RecipeMe.Views.UserProfile({user: response})
        new RecipeMe.Views.HeaderView({el: '.app-header'})
        $("section#main").slideUp().html(view.render().el).slideDown()
      {patch: true})

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