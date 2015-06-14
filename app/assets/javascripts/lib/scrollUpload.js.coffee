window.scrollUpload =
  init: (page, url, uploadPlaceholder, callback, collection = []) ->
    window.page = page
    window.url = url
    window.successCallback = callback
    window.placeholder = uploadPlaceholder
    window.collection = collection
    $(document).on('scroll', this.setUploadImage)

  setUploadImage: ->
    if $(document).height() <= $(window).scrollTop() + $(window).height()
      if $(".upload-image").length == 0
        gif = $("<img src='/images/ajax-loader.gif' class='upload-image'/>")
        $(window.placeholder).after(gif)
        setTimeout(window.scrollUpload.upload, 1000)
      return false
    else
      return

  upload: ->
    $.ajax window.url,
      type: "GET"
      data: {page: ++window.page}
      success: (response, request) ->
        window.successCallback(response, request, collection)
        $(".upload-image").remove()



