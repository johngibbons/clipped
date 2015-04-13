$ ->
  $(".js-link").click ->
    $(@).addClass("hidden")
    $(@).closest(".card").find(".edit-upload-form").removeClass("hidden")

    if $(@).is("#edit-tags-link")
      $(".tags-list").addClass("update")
      $("#upload_tag_list").val("")
      $("#upload_tag_list").focus()
      $("#update-tags-btn").removeClass("hidden")
      $('.tag').each( (index, element) ->
        tagName = element.textContent
        element.innerHTML = '<span class="tag-data">'+ tagName + '</span>' + '<span class="delete-tag fa fa-remove"></span>'
      )

