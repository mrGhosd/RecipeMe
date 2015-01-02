class RecipeMe.Views.CommentForm extends Backbone.View
  template: JST['comments/form']
  events:
    'submit #comment_form': 'commentAction'
    'click .cancel-button': 'showComment'

  initialize: ->
    this.render()

  commentAction: (event)->
    event.preventDefault()
    attributes = window.appHelper.formSerialization($("#comment_form"))
    if @model.comment
      comment = new RecipeMe.Models.Comment({recipe: @model.recipe.get("id"), id: @model.comment.get('id')})
      comment.save(attributes,
        success: (response, request)->
          console.log response
          console.log request
          view = new RecipeMe.Views.Comment({model: response})
          $(".row.comment-form").parent().prev("div").html(view.render().el).show()
          $(".row.comment-form").parent().remove()
        error: (response, request)->
          console.log response
          console.log request
      ,{patch: true})
    else
      console.log @model
      comment = new RecipeMe.Models.Comment({recipe: @model.recipe.get("id")})
      comment.save(attributes,
        success: (response, request)->
          RecipeMe.currentUser.get('comments').push(response)
          view = new RecipeMe.Views.Comment(model: response)
          $(".recipe-comments").prepend(view.render().el)
          $(".row.comment-form").parent().prev("div").show()
          $(".row.comment-form").parent().remove()
        error: (response, request) ->
          console.log "error"
      )

  showComment: ->
    $(".row.comment-form").parent().prev("div").show()
    $(".row.comment-form").parent().remove()

  render: ->
    $(@el).html(@template(options: @model))
    $(".markItUp").markItUp(myHtmlSettings)
    this
