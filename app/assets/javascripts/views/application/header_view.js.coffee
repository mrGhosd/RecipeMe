class RecipeMe.Views.HeaderView extends Backbone.View

  template: JST['application/header']

  events:
    "click .login-window": 'loginDialog'
    "click .registration-window": 'registrationDialog'
    "click .sign-out-button": 'signOut'
    "click .menu-item": 'showNavigationMenu'
    "click .locale-switcher": 'toggleCurrentLocale'

  initialize: ->
    this.render()
    @width = window.screen.width
    @navigation_width = 300

  loginDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})
    login = new RecipeMe.Views.LoginView({el: ".actions-views"})

  registrationDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})
    $("#authModal .nav-tabs li").removeClass("active")
    $("#authModal .nav-tabs li.sign_up").addClass("active")
    registration = new RecipeMe.Views.RegistrationView({el: ".actions-views"})

  signOut: ->
    $.ajax "/users/sign_out",
      type: "DELETE"
      success: (data, textStatus, jqXHR) ->
        window.location.reload()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR.responseText

  showNavigationMenu: ->
    this.toggleLeftMenu()


  toggleLeftMenu: (handler = true)->
    if $("#navigationMenu").width() == 0 && handler
      if $("#navigationMenu .quick-panel").length == 0
        view = new RecipeMe.Views.NavigationView({el: '#navigationMenu', view: this}  )
      else
        $("#navigationMenu .quick-panel").show()

      $(".app-header").animate({width: "#{@width - @navigation_width}px", left: "#{@navigation_width}px"}, 250)
      $("#navigationMenu").show().animate({width: "#{@navigation_width}" }, 250)
      $(".mask").removeClass("hide")
    else
      $(".app-header").animate({width: "100%", left: "0px"}, 250)
      $("#navigationMenu").queue(->
        $(this).animate({width: "0px"}, 250)
        $(this).find(".quick-panel").hide()
        $(this).dequeue()
      )
      $(".mask").addClass("hide")

  toggleCurrentLocale: (event) ->
    event.preventDefault()
    $.ajax "api/users/locale",
      type: "POST"
      data: {locale: $(event.target).text()}
      success: (data, textStatus, jqXHR) ->
        window.location.reload()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR.responseText



  render: ->
    $(@el).html(@template())
    this