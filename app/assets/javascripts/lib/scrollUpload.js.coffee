window.scrollUpload =
  init: (page, url, uploadPlaceholder, callback) ->
    window.page = page
    window.url = url
    window.successCallback = callback
    window.placeholder = uploadPlaceholder
    $(window).on('scroll', this.setUploadImage)

  setUploadImage: ->
    if $(document).height() <= $(window).scrollTop() + $(window).height()
      if $(".upload-image").length == 0
        gif = $("<img src='/images/ajax-loader.gif' class='upload-image'/>")
        $(window.placeholder).after(gif)
      setTimeout(window.scrollUpload.upload, 1000)


  upload: ->
    $.ajax window.url,
      type: "GET"
      data: {page: ++window.page}
      success: (response, request) ->
        window.successCallback(response, request)
    $(".upload-image").remove()



