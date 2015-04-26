$(document).ready(function () {

  formatTags("#upload_tag_list");

  $('#update-tags-btn').click(function() {
    $('#update-tags-form').submit();
  })

  $("#update-tags-form").on("ajax:before", function(){
    tags = getTags($(".tag-data").get());
    $('#update-tags-form').addClass("hidden");
    $('#upload_tag_list').val(tags);
    $('.temporary').remove();
  }).on("ajax:error", function(e, xhr, status, error) {
    $("#update-tags-form").append("<p>ERROR</p>");
  });

  //deleting functionality
  $(document).on( "click", ".delete-tag", function(e) {
    e.preventDefault();
    $(this).parent().remove();
  });
});