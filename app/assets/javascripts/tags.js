var TagsEditor = function (upload) {
  this.$upload = $(upload);
  this.$upload.id = this.$upload.data("id");
  this.$inputField = this.$upload.find("input#upload_tag_list");
  this.$tags = this.$upload.find(".tag");
  this.$tagsContainer = this.$upload.find(".tags-container");
  this.$editButton = this.$upload.find(".edit-tags");

  this.getTags();
  this.bindHandlers();
};

TagsEditor.prototype.getTags = function(){
  var self = this;

  var tags = [];
  self.$tags = self.$upload.find(".tag");

  if ( self.$tags.length ) {
    self.$tags.each(function(){
      tags.push( $(this).text() );
    });
  }

  self.tagList = tags.join();

};

TagsEditor.prototype.bindHandlers = function(){
  var self = this;

  self.$editButton.on("click.edit", function(){
    self.makeEditable();
  });

  self.$inputField.on("keyup", function(e){

    self.checkEnter(e);

    if(/(188|13)/.test(e.which)) {
      self.$inputField.focusout();
    } else if(/^8$/.test(e.which)) {
      if( self.$inputField.val().length === 0 ) {
        self.$tags.last().remove();
      }
    }

  });

  self.$upload.on("focusout", function(){
    self.updateTags();
  });
};

TagsEditor.prototype.checkEnter = function(e){
  var self = this;

  e = e || event;
  var txtArea = /textarea/i.test((e.target || e.srcElement));
  return txtArea || (e.keyCode || e.which || e.charCode || 0) !== 13;
};

TagsEditor.prototype.updateTags = function(){
  var self = this;

  var loadingGIF = self.$upload.find(".loading-gif");
  loadingGIF.removeClass("hidden");

  var txt = self.$inputField.val().replace(/[^a-zA-Z0-9\s]/g,'');

  if (txt) {
    self.$tagsContainer.append("<span class='tag'><span class='tag-data'>" + txt.toLowerCase() + "</span>" + "<span class='delete-tag fa fa-remove'></span></span>");
  }

  self.getTags();

  $.ajax({
    url: '/uploads/' + self.$upload.id,
    type: 'PUT',
    dataType: "json",
    data: { upload: { tag_list: self.tagList } },
    success: function(){
      loadingGIF.addClass("hidden");
      if (self.$upload.find(".warning").length && self.tagList.length) {
        self.removeWarning();
      }
    },
  });

  self.$inputField.val("");
};

TagsEditor.prototype.removeWarning = function(){
  var self = this;

  self.$upload.find(".warning").remove();
  self.$upload.removeClass("no-tags");
};

TagsEditor.prototype.makeEditable = function(){
  var self = this;

  self.$editButton.off("click.edit");
  self.$tags.each(function(i, el) {
    txt = el.textContent;
    el.innerHTML = "<span class='tag-txt'>" + txt + "</span>" +
      "<span class='delete-tag fa fa-remove'></span>";
  });

  self.$inputField.removeClass("hidden");
  self.$inputField.focus();
  self.$editButton.text("Done");

  self.$editButton.on("click.finish", function(){
    self.finishEditing();
  });
};

TagsEditor.prototype.finishEditing = function(){
  var self = this;

  self.$inputField.addClass("hidden");
  self.$editButton.text("Edit Tags");
  self.$tags.each(function(i, el) {
    $(el).find(".delete-tag").remove();
  });
  self.$editButton.off("click.finish");
  self.$editButton.on("click.edit", function(){
    self.makeEditable();
  });
};

$(document).ready(function () {

  //deleting functionality
  $(document).on( "click", ".delete-tag", function(e) {
    e.preventDefault();
    $(this).parent().remove();
  });
});
