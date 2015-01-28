# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  #make sure images fill thumbnail containers

  $(".grid-item").each ->
    
    # Uncomment the following if you need to make this dynamic
    refH = $(this).height()
    refW = $(this).width()
    refRatio = refW / refH
    
    # Hard coded value...
    # refRatio = 1
    image = $(this).children("img")
    image.removeClass "portrait"
    image.removeClass "landscape"
    console.log image
    imgH = {}
    imgW = {}

    image.load ->
      imgH = image.height()
      imgW = image.width()
      console.log imgH
      console.log imgW
    
      if (imgW / imgH) < refRatio
        image.addClass "portrait"
      else
        image.addClass "landscape"

    $("#s3_uploader").S3Uploader
      
        remove_completed_progress_bar: false,
        progress_bar_target: $('#uploads_container')

    $("#s3_uploader").bind "s3_upload_failed", (e, content) ->
      alert content.filename + "failed to upload"

    return
