class RecipeMe.RecipesController

  index: ->
    this.loadRecipesCollection()
    view = new RecipeMe.Views.RecipesIndex({collection: @collection})
    $("section#main").html(view.el)
    view.render()
    showDialog = ->
      modal = new RecipeMe.Views.CommonModal(el: ".modal")
#      $("#myModal").html($(modal.render().el).modal('show'))
      $("#common-modal").removeClass("modal-lg")
      $("#common-modal .modal-title").html("#{I18n.t('application.additional_email.title')}")
      $("#common-modal .modal-body").html("<h1>Some Text</h1>")
      $("#myModal").modal('show')
    setTimeout showDialog, 100 if Backbone.history.location.pathname == "/users/password/edit"

  new: ->
    this.loadRecipesCollection()
    if RecipeMe.currentUser
      view = new RecipeMe.Views.RecipesForm({collection: @collection})
      $("section#main").html(view.el)
      view.render()
    else
      new RecipeMe.ErrorHandler().forbidden()

  show: (id) ->
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model)->
        view = new RecipeMe.Views.RecipeShow(model: model)
        $("section#main").html(view.el)
        view.render()
      error: (response, request) ->
        new RecipeMe.ErrorHandler(response, request).showErrorPage()

  edit: (id) ->
    recipe = new RecipeMe.Models.Recipe(id: id)
    recipe.fetch
      success: (model) ->
        if RecipeMe.currentUser && RecipeMe.currentUser.isResourceOwner(model)
          view = new RecipeMe.Views.RecipesForm({model: model})
          $("section#main").html(view.el)
          view.render()
        else
          new RecipeMe.ErrorHandler().forbidden()
      error: (response, request) ->
        new RecipeMe.ErrorHandler(response, request).showErrorPage()

  loadRecipesCollection: ->
    @collection = new RecipeMe.Collections.Recipes()
    @collection.fetch({reset: true})