$('.users.edit').ready(function () {

  var ratio = $('#cropbox').data('ratio');
  var crop_x = $('#cropbox').data('crop-x');
  var crop_y = $('#cropbox').data('crop-y');
  var crop_w = $('#cropbox').data('crop-w');
  var crop_h = $('#cropbox').data('crop-h');
  crop_x /= ratio;
  crop_y /= ratio;
  crop_w /= ratio;
  crop_h /= ratio;
  var large_img_w = $('#cropbox').data('large-img-w');
  var large_img_h = $('#cropbox').data('large-img-h');
  var large_img_url = $('#cropbox').data('large-img-url');
  var jcrop_api;

  $("#edit-crop").click(function() {
    $("#submit-crop").show();
    $(this).hide();
    $("#previewHolder").attr('src', large_img_url);
    $("#previewHolder").removeClass("avatar");
    $("#profile-preview").addClass("avatar");
    $("#profile-preview").css("box-sizing", "content-box");
    $('#cropbox').Jcrop({
      onChange: update_crop,
      onSelect: update_crop,
      setSelect: [ crop_x, crop_y, crop_x + crop_w, crop_y + crop_h ],
      aspectRatio: 1
    }, function() {
      jcrop_api = this;
    });
    $(".jcrop-holder").show();
    $("#user_avatar").hide();
  });

  $("#submit-crop").click(function() {
    $(this).hide();
    $(".jcrop-holder").hide();
    $("#edit-crop").show();
    jcrop_api.destroy();  
    $("#user_avatar").show();
    $("#cropbox").hide();
  });

  function update_crop(coords) {
    console.log(coords);
    var rx = 150/coords.w;
    var ry = 150/coords.h;
    $('#previewHolder').css({
      width: Math.round(rx * large_img_w) + 'px',
      height: Math.round(ry * large_img_h) + 'px',
      marginLeft: '-' + Math.round(rx * coords.x) + 'px',
      marginTop: '-' + Math.round(ry * coords.y) + 'px'
    });

    crop_x = coords.x;
    crop_y = coords.y;
    crop_w = coords.w;
    crop_h = coords.h;

    $('#crop_x').val(Math.floor(crop_x * ratio));
    $('#crop_y').val(Math.floor(crop_y * ratio));
    $('#crop_w').val(Math.floor(crop_w * ratio));
    $('#crop_h').val(Math.floor(crop_h * ratio));
  }

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        var image = new Image();
        image.src = e.target.result;

        image.onload = function() {
          w = this.width;
          h = this.height;
          if (w > h) {
            var mult = 150 / h;
            var img_w =  Math.round(mult * w);
            $('#previewHolder').attr({  
              height: 150,
              width: img_w 
            });
          }
          else {
            var mult = 150 / w;
            var img_h = Math.round(mult * h);
            $('#previewHolder').attr({  
              width: 150,
              height: img_h
            });
          }
          $('#previewHolder').attr('src', this.src);
          $('#previewHolder').removeClass("avatar");
          $('#previewHolder').css({
            width: "",
            height: ""
          });
          $("#profile-preview").css("box-sizing", "content-box");
          $('#profile-preview').addClass("avatar");

          $("#submit-crop").show();
          $("#edit-crop").hide();

          $("#cropbox").attr('src', this.src);
          if (w > h) {
            var mult = 500 / w;
            var img_h =  Math.round(mult * h);
            large_img_w = 500;
            large_img_h = img_h;
            ratio = w / large_img_w;
            $('#cropbox').attr('height', img_h);
            $('#cropbox').attr('width', 500);
            $('#cropbox').css({
              width: "",
              height: ""
            });
          }
          else {
            var mult = 500 / h;
            var img_w = Math.round(mult * w);
            large_img_w = img_w;
            large_img_h = 500;
            ratio = w / large_img_w;
            $('#cropbox').attr('width', img_w);
            $('#cropbox').attr('height', 500);
            $('#cropbox').css({
              width: "",
              height: ""
            });
          }

          $('#cropbox').Jcrop({
            onChange: update_crop,
            onSelect: update_crop,
            setSelect: [0,0,500,500],
            aspectRatio: 1
            }, function() {
              jcrop_api = this;
            });
          $(".jcrop-holder").show();


          $("#edit-crop").click(function() {
            $("#previewHolder").attr('src', image.src);
          });
        };
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  $("#user_avatar").change(function() {
    readURL(this);
  });

});


