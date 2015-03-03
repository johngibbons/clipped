$(document).ready(function () {
  console.log("ready");
  $("#edit-tags-link").click(function() {
    console.log("click");
    $(".tags-form").toggleClass("hidden");
  });
});