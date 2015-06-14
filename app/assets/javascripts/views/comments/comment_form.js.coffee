class RecipeMe.Views.CommentForm extends Backbone.View
  template: JST['comments/form']
  events:
    'submit #comment_form': 'commentAction'
    'click .cancel-button': 'showComment'

  initialize: ->
    if @model.comment
      @comment = @model.comment
    else
      @comment = new RecipeMe.Models.Comment({recipe: @model.recipe.get("id"), user: RecipeMe.currentUser})
    this.render()

  commentAction: (event)->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#comment_form"))
#    @comment.set({collection: @model.collection})
    @comment.save attributes,
      success: (response, request)->
        console.log request
      error: (response, request)->
        errors = request.responseJSON
        $.each errors, (key, value)->
          $("#comment_form textarea[name=\"#{key}\"]").addClass("error")
          $("<div class='error-text'>#{value[0]}</div>").insertAfter($("#comment_form textarea[name=\"#{key}\"]"))

  showComment: ->
    $(".row.comment-form").parent().prev("div").show()
    $(".row.comment-form").parent().remove()

  render: ->
    $(@el).html(@template(options: @model))
    this
