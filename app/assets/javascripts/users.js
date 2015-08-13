
var profilePicture = {

  $cropImage: null,
  $submitLink: null,
  $submitForm: null,
  $cancelLink: null,
  $avatarContainer: null,
  $avatarImage: null,
  $input: null,
  image: {},

  init: function(options) {
    var self = this;

    //default values
    self.$cropImage = $("#cropbox");
    self.$submitLink = $("#submit-crop");
    self.$submitForm = $("#edit-user-form");
    self.$cancelLink = $(".modal-close, .modal-fade-screen");
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

    self.$submitForm.on("submit", function(e){
      self.submitCrop(e);
    });

    self.$cancelLink.on("click", function(e){
      self.cancelCrop(e);
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

    var tempImage = new Image();
    tempImage.src = self.$cropImage.attr("src");
    self.$cropImage.nw = tempImage.naturalWidth;
    self.$cropImage.nh = tempImage.naturalHeight;


    self.$avatarContainer.w = self.$avatarContainer.width();
    self.$avatarContainer.h = self.$avatarContainer.height();
    console.log(self.$avatarContainer.w);
    console.log(self.$avatarContainer.h);
  },

  initiateCrop: function(e) {
    var self = this;

      self.$cropImage.Jcrop({
        boxWidth: 330,
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

  parseURLFromUploaded: function(input) {
    var self = this;

    var file = input.files[0];
    var fileType = /image.*/;

    if ( file.type.match(fileType) ) {

      var reader = new FileReader();

      reader.onload = function() {
        self.generatePreviewFromUpload(reader);
      }

      reader.readAsDataURL(file);

    } else {
      alert("file must be an image");
    }

  },

  generatePreviewFromUpload: function(reader) {
    var self = this;

    var newImage = new Image();
    newImage.src = reader.result;
    self.$cropImage.nw = newImage.naturalWidth;
    self.$cropImage.nh = newImage.naturalHeight;

    newImage.onload = function() {
      self.jcropApi.setImage(newImage.src, function(){
        self.jcropApi.setSelect([0, 0, self.$cropImage.nw, self.$cropImage.nh]);
      });
      self.$avatarImage.attr('src', newImage.src);
    };
  },

  submitCrop: function(e) {
    var self = this;

    $(".modal-saving").show();

  },

  cancelCrop: function(e) {
    var self = this;

    self.jcropApi.destroy();
    self.$avatarImage.attr("src", self.$cropImage.attr("src"));
  },

};


$(".users.edit, .users.show").ready(function() {

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


