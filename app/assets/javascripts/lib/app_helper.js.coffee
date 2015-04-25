window.appHelper =
    itWork: (event) ->
        alert("ITWORK!!")

    uploadFile: (file, successCallback) ->

    formSerialization: (form)->
      attributes = {}
      elements = $('input, select, textarea', form)

      for element in elements
        if $(element).attr("type") == "submit" || $(element).attr("steps") || $(element).attr("ingridients")
          continue
        if $(element).attr("type") == "file"
          if $(element)[0].files[0] && form.attr("id") == $("#user_form").attr("id")
            attributes["#{$(element).attr('name')}"] =  $(element)[0].files[0]
          continue

        attributes["#{$(element).attr('name')}"] = $(element).val()

      return attributes

    serializeSteps: (form)->
      steps = []
      elements = $('.step-block', form)
      for element, index in elements
        step = {}
        description = $(element).find("textarea").val()
        image = $(element).find("input.step_image_id").val()
        step["description"] = description
        step["image"] =  image
        steps[index] = step
      return steps



    arrayCheck: (array, object) ->
      found = false
      for element in array
        if element.id == object.get("id")
          found = true
          return found

    collectionCheck: (collection, object) ->
      found = false
      for element in collection.models
        if element.get("id") == object.get("id")
          found = true
          return found
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

    dateOfBirthFormat: (date) ->
      d = new Date(date)
      dformat = [this.monthValue(d.getDate()),
                 this.monthValue(d.getMonth()+1),
                 d.getFullYear()].join('.')
      return dformat

    dateOfBirthReverseFormat: (date) ->
      d = new Date(date)
      dformat = [d.getFullYear(),
                 this.monthValue(d.getMonth() + 1),
                 this.monthValue(d.getDate())
                 ].join('-')
      return dformat

    monthValue: (month) ->
      "0"+month.toString() if month.toString().length == 1



    dragAndDrop: (input) ->
      dropZone = $('.image-placeholder')
      maxFileSize = 1000000
      console.log dropZone

      if  typeof(window.FileReader == 'undefined')
        dropZone.text('Не поддерживается браузером!');
        dropZone.addClass('error');

      dropZone[0].ondragover = ->
        dropZone.addClass("hover")
        return false

      dropZone[0].ondragleave = ->
        dropZone.removeClass("hover")
        return false


