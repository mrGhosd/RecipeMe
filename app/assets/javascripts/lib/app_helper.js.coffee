window.appHelper =
    itWork: (event) ->
        alert("ITWORK!!")

    uploadFile: (file, successCallback) ->

    formSerialization: (form)->
      attributes = {}
      elements = $('input, select, textarea', form)

      for element in elements
        if $(element).attr("type") == "submit"
          continue
        if $(element).attr("type") == "file"
          attributes[$(element).attr('name')] = $(element)[0].files[0] if $(element)[0].files[0]
          continue

        attributes[$(element).attr('name')] = $(element).val()

      return attributes

    currentUser: ->
      if RecipeMe.currentUser
        user =  RecipeMe.currentUser
      else
        user = null

      return user

    render_partial: ( path, options = {} ) ->
      # add the leading underscore (like rails-partials)
      path = path.split('/')
      path[ path.length - 1 ] = '_' + path[ path.length - 1 ]
      path = path.join('/')
      # render and return the partial if existing
      try
        JST["#{ path }"]( options )
      catch error
        # if App.Environment != 'production' then "<p class='error'>Sorry, there is no partial named '#{ path }'.</p>" else ''
        "<p class='error'>Sorry, there is no partial named '#{ path }'.</p>"