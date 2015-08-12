
var profilePicture = {

  $cropImage: null,
  $editLink: null,
  $submitLink: null,
  $avatarContainer: null,
  $avatarImage: null,
  $input: null,
  image: {},

  init: function(options) {
    var self = this;

    //default values
    self.$cropImage = $("#cropbox");
    self.$editLink = $(".modal-trigger");
    self.$submitLink = $("#submit-crop");
    self.$avatarContainer = $("#avatar-preview-container");
    self.$avatarImage = $("#avatar-preview");
    self.$input = $("#avatar-upload");

    //if any options, overwrite defaults
    $.extend(self, options);
    self.imageURL = self.$cropImage.data("image-url");

    self.bindHandlers();
    self.calculateDimensions();
    self.initiateCrop();
  },

  bindHandlers: function() {
    var self = this;

    self.$submitLink.on("click", function(e){
      self.submitCrop(e);
    });

    self.$input.on("change", function() {
      self.parseURLFromUploaded(this);
    });

  },

  calculateDimensions: function() {
    var self = this;

    self.cropX = self.$cropImage.data("crop-x");
    self.cropY = self.$cropImage.data("crop-y");
    self.cropW = self.$cropImage.data("crop-w");
    self.cropH = self.$cropImage.data("crop-h");

    self.$cropImage.w = self.$cropImage.outerWidth();
    self.$cropImage.h = self.$cropImage.outerHeight();

    var tempImage = new Image();
    tempImage.src = self.$cropImage.attr("src");
    self.$cropImage.nw = tempImage.naturalWidth;
    self.$cropImage.nh = tempImage.naturalHeight;
    console.log(self.$cropImage.nw);
    console.log(self.$cropImage.nh);

    self.$avatarImage.w = self.$avatarImage.outerWidth();
    self.$avatarImage.h = self.$avatarImage.outerHeight();

    self.$avatarContainer.w = self.$avatarContainer.outerWidth();
    self.$avatarContainer.h = self.$avatarContainer.outerHeight();
  },

  initiateCrop: function(e) {
    var self = this;

      self.$avatarImage.attr("src", self.imageURL).removeClass("avatar");
      self.$avatarContainer.addClass("avatar").css("box-sizing", "content-box");
      self.$cropImage.Jcrop({
        boxWidth: 450,
        boxHeight: 300,
        setSelect: [ self.cropX, self.cropY, self.cropX + self.cropW, self.cropY + self.cropH ],
        onChange: self.updateCrop,
        onSelect: self.updateCrop,
        aspectRatio: 1,
      }, function() {
        self.jcropApi = this;
      });
  },

  updateCrop: function(coords){
    var self = profilePicture;

    var rx = self.$avatarContainer.w/coords.w;
    var ry = self.$avatarContainer.h/coords.h;

    console.log("avatarcontainerwidth", self.$avatarContainer.w);
    console.log("avatarcontainerheight", self.$avatarContainer.h);
    console.log("coords", coords);
    console.log("naturalWidth", self.$cropImage.nw);
    console.log("naturalHeight", self.$cropImage.nh);

    self.$avatarImage.css({
      width: Math.round(rx * self.$cropImage.nw) + 'px',
      height: Math.round(ry * self.$cropImage.nh) + 'px',
      marginLeft: '-' + Math.round(rx * coords.x) + 'px',
      marginTop: '-' + Math.round(ry * coords.y) + 'px'
    });

    self.cropX = coords.x;
    self.cropY = coords.y;
    self.cropW = coords.w;
    self.cropH = coords.h;

    $('#crop_x').val(Math.floor(self.cropX));
    $('#crop_y').val(Math.floor(self.cropY));
    $('#crop_w').val(Math.floor(self.cropW));
    $('#crop_h').val(Math.floor(self.cropH));
  },

  submitCrop: function(e) {
    var self = this;

    self.$submitLink.on("ajax:success", function(e, data, status, xhr) {
      console.log("ajax success");
      $(".jcrop-holder").hide();
      self.jcropApi.destroy();
      self.$cropImage.hide();

      self.calculateDimensions();
    });
  },

  parseURLFromUploaded: function(input) {
    var self = this;

    var file = input.files[0];
    var fileType = /image.*/;

    if ( file.type.match(fileType) ) {

      var reader = new FileReader();

      reader.onload = function(e) {
        self.generatePreviewFromUpload(e, reader);
      }

      reader.readAsDataURL(file);

    } else {
      alert("file must be an image");
    }

  },

  generatePreviewFromUpload: function(e, reader) {
    var self = this;

    self.newImage = new Image();
    self.newImage.src = reader.result;
    self.$cropImage.nw = self.newImage.naturalWidth;
    self.$cropImage.nh = self.newImage.naturalHeight;

    self.newImage.onload = function() {
      self.setCropboxImage(this);
      self.setAvatarPreview(this);
    };
  },

  setAvatarPreview: function(image) {
    var self = this;

    self.$avatarImage.attr('src', image.src).removeClass("avatar");

    if ( w >= h ) {
      var origToAvatarRatio = self.$avatarImage.h / self.$cropImage.nh;
      var previewWidth = Math.round( origToAvatarRatio * $self.$cropImage.nw );
      self.$avatarImage.css({
        height: self.$avatarImage.h + "px",
        width: previewWidth + "px"
      });
    } else {
      var origToAvatarRatio = self.$avatarImage.w / self.$cropImage.nw;
      var previewHeight = Math.round( origToAvatarRatio * self.$cropImage.nh );
      self.$avatarImage.css({
        height: previewHeight + "px",
        width: self.$avatarImage.w + "px"
      });
    }

    self.$avatarContainer.css("box-sizing", "content-box").addClass("avatar");

  },

  setCropboxImage: function(image) {
    var self = this;

    self.$cropImage.w = $(".jcrop-holder").outerWidth();
    self.$cropImage.h = $(".jcrop-holder").outerHeight();

    self.jcropApi.setImage(image.src, function(){
      self.jcropApi.setSelect([0, 0, self.$cropImage.nw, self.$cropImage.nh]);
    });
  }
};


$(".users.edit").ready(function() {

  $(".modal-trigger").on("click", function(){
    profilePicture.init();
  });

  $(".modal-trigger").on("mouseenter", function(){
    $(".hover-overlay").addClass("animated zoomIn").css("display", "block");
  }).on("mouseleave", function(){
    $(".hover-overlay").removeClass("zoomIn").addClass("zoomOut");
    setTimeout(function(){
      $(".hover-overlay").removeClass("zoomOut").css("display", "none");
    }, 300);
  });

});

$('.users.show').ready(function () { 
  $('#user-sort-tabs').on('click', 'a', function(event) {
    if (!$(this).hasClass("active")) {
      var tabs = $(this).closest(".tabs");
      tabs.find(".active").removeClass("active");
      $(this).addClass("active");
    }
  });
});


