$(document).ready(function () {
  $("#edit-tags-link").click(function() {
    console.log("click");
    $(".tags-form").removeClass("hidden");
    $(".js-link").addClass("hidden");
    $(".tags-list").addClass("update");
    $("#update-tags-btn").removeClass("hidden");
  });

  $('.tags-list input').on('focusout',function(){    
  var txt= this.value.replace(/[^a-zA-Z0-9\+\-\.\#\s]/g,''); // allowed characters
  if(txt) {
    $(this).before('<span class="tag">'+ txt.toLowerCase() +'</span>');
  }
  this.value="";

  }).on('keyup',function( e ){
    // if: comma,enter (delimit more keyCodes with | pipe)
    if(/(188|13)/.test(e.which)) {
      $(this).focusout(); 
    }
    else if(/^8$/.test(e.which)) {
      if(deleteNextIteration) {
        $(this).prev(".tag").remove();
        i=0;
      }
    }

    if($(this).val().length == 0 ) {
      deleteNextIteration = true;
    }
    else {
      deleteNextIteration = false;
    }
  });

  $('#update-tags-btn').submit();
});

$.trim($("#spa").val());