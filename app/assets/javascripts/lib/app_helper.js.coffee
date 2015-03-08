window.appHelper =
    itWork: (event) ->
        alert("ITWORK!!")

    uploadFile: (file, successCallback) ->

    formSerialization: (form)->
      attributes = {}
      elements = $('input, select, textarea', form)
      if $('[steps=true]')
        attributes["[steps]"] = this.serializeSteps(form)

      for element in elements
        if $(element).attr("type") == "submit" || $(element).attr("steps")
          continue
        if $(element).attr("type") == "file"
          attributes["#{$(element).attr('name')}"] =  $(element)[0].files[0] if $(element)[0].files[0]

          continue
        attributes["#{$(element).attr('name')}"] = $(element).val()

      return attributes

    serializeSteps: (form)->
      steps = []
      elements = $('.step-block', form)
      for element, index in elements
        step = {}
        description = $(element).find("textarea").val()
        image = $(element).find("input[type=file]")[0].files[0]
        step["[description]"] = description
        step["[image]"] =  image
        steps[index] = step

      console.log steps
      return steps



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


