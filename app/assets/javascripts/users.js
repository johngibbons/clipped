$('.users.edit').ready(function () {

  $("#edit-crop").on("click", function() {
    $("#submit-crop").show();
    $(this).hide();
  }); 

  $("#submit-crop").on("click", function() {
    $(this).hide();
    $(".jcrop-holder").hide();
    $("#edit-crop").show();
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#previewHolder').attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  $("#user_avatar").change(function() {
    readURL(this);
  });

});


