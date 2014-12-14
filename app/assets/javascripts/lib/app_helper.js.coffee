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
