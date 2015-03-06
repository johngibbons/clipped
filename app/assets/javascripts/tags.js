$(document).ready(function () {

  deleteNextIteration = true;

  $('#upload_tag_list').on('focusout',function(){    
  var txt= this.value.replace(/[^a-zA-Z0-9\+\-\.\#\s]/g,''); // allowed characters
  if(txt) {
    $(this).before('<span class="temporary tag"><span class="tag-data">'+ txt.toLowerCase() + '</span>' + '<span class="delete-tag fa fa-remove"></span></span>');
  }
  this.value="";

  }).on('keyup',function( e ){
    // if: comma,enter (delimit more keyCodes with | pipe)
    if(/^188$/.test(e.which)) {
      if(e.keyCode == 13) {
        e.preventDefault;
        return false;
      }
      $(this).focusout(); 
    }

    else if((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
      $('button[type=submit] .default').click();
      return false;
    }
    else if(/^8$/.test(e.which)) {
      if(deleteNextIteration) {
        $('.tag').last().remove();
      }
    }

    if($(this).val().length == 0 ) {
      deleteNextIteration = true;
    }
    else {
      deleteNextIteration = false;
    }
  });

  function get_tags( tags ) {
    var a = [];
    for ( var i = 0; i < tags.length; i++ ) {
      a.push( tags[ i ].textContent );
    }
    return a.join();
  }

  $('#update-tags-btn').click(function() {
    $('#update-tags-form').submit();
  })

  $("#update-tags-form").on("ajax:before", function(){
    tags = get_tags($(".tag-data").get());
    $('#update-tags-form').addClass("hidden");
    $('#upload_tag_list').val(tags);
    $('.temporary').remove();
    console.log("here");
  }).on("ajax:error", function(e, xhr, status, error) {
    $("#update-tags-form").append("<p>ERROR</p>");
  });

});