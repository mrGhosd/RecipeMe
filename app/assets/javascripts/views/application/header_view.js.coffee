class RecipeMe.Views.HeaderView extends Backbone.View

  template: JST['application/header']

  events:
    "click .login-window": 'loginDialog'
    "click .registration-window": 'registrationDialog'
    "click .sign-out-button": 'signOut'
    "click .menu-item": 'showNavigationMenu'
    "click .locale-switcher": 'toggleCurrentLocale'
    'click .search-button': 'sendSearchRequest'
    'keyup .search-field': 'sendSearchRequest'

  initialize: ->
    @updates_counter = 0
    @update_element = $("<span class='label label-danger user-notification'></span>")
    @listenTo(Backbone, "User", @updateUserData)
    this.render()
    @width = window.screen.width
    @navigation_width = 300

  loginDialog: ->
    modalView = new RecipeMe.Views.ModalWindow({el: ".modal"})
    login = new RecipeMe.Views.LoginView({el: ".actions-views"})

  updateUserData: (data) ->
    if parseInt(data.id, 10) == parseInt(RecipeMe.currentUser.get("id"), 10)
      if data.action == "follow"
        @updates_counter++
      if data.action == "unfollow"
        if @updates_counter > 0
          @updates_counter--
        else
          @updates_counter = 0
      if data.action == "update"
        this.render()
      if data.action == "feed"
        @updates_counter++
      this.displayNavMenuNotification() if $("#navigationMenu").width() == 0


  displayNavMenuNotification: ->
    console.log @updates_counter
    if @updates_counter <= 0
      $(".left-menu-opener").find(".label.label-danger.user-notification").remove()
    else
      $(".left-menu-opener").append(@update_element)
      @update_element.text(@updates_counter)

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

  sendSearchRequest: (event) ->
    text = $(".search-field").val()
    if(text.length == 0)
      window.history.back()
    else
      search = new RecipeMe.SearchController(text)
      search.search(search.searchByAllFields, text)


  toggleLeftMenu: (handler = true)->
    if @updates_counter > 0
      $(".user-notification").remove()

    @update_counter = 0
    if $("#navigationMenu").width() == 0 && handler
      $(".app-header").animate({width: "#{@width - @navigation_width}px", left: "#{@navigation_width}px"}, 250)
      $("#navigationMenu").show().animate({width: "#{@navigation_width}" }, 250)
      $(".mask").removeClass("hide")
    else
      $(".app-header").animate({width: "100%", left: "0px"}, 250)
      $("#navigationMenu").queue(->
        $(this).animate({width: "0px", display: "none"}, 250)
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