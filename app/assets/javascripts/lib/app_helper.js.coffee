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


    arrayCheck: (array, object) ->
      found = false
      for element in array
        if element.id == object.get("id")
          found = true
          return found

    dateFormater: (date) ->
      d = new Date(date)
      dformat = [d.getHours(),
                 d.getMinutes(),
                 d.getSeconds()].join(':') + ' ' +
                [d.getMonth()+1,
                 d.getDate(),
                 d.getFullYear()].join('.')
      return dformat