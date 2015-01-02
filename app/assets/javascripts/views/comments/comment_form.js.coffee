class RecipeMe.Views.CommentForm extends Backbone.View
  template: JST['comments/form']
  events:
    'submit #comment_form': 'commentAction'
    'click .cancel-button': 'showComment'

  initialize: ->
    console.log @model.comment
    this.render()

  commentAction: (event)->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#comment_form"))
    comment = new RecipeMe.Models.Comment(recipe: @model.recipe.get("id"))
    if @model.comment
      @model.comment.save(attributes,
        success: (response, request)->
          $(".row.comment-form").parent().prev("div").show()
          $(".row.comment-form").parent().remove()
        error: (response, request)->
          console.log response
          console.log request
      ,{patch: true})
    else
      comment.save(attributes,
        success: (response, request)->
          view = new RecipeMe.Views.Comment(model: response)
          $(".recipe-comments").append(view.render().el)
        error: (response, request) ->
          console.log "error"
      )

  showComment: ->
    $(".row.comment-form").parent().prev("div").show()
    $(".row.comment-form").parent().remove()

  render: ->
    console.log @model
    $(@el).html(@template(options: @model))
    this