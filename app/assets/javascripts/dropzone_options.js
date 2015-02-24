var ready;
ready = function() {

 	// disable auto discover
	Dropzone.autoDiscover = false;

 	var dropzone = new Dropzone( ".dropzone", {
		maxFilesize: 50, // Set the maximum file size to 50 MB
		maxThumbnailFilesize: 50,
		paramName: "file", // Rails expects the file upload to be something like model[field_name]
		addRemoveLinks: false, // Don't show remove links on dropzone itself.
		acceptedFiles: 'image/*',
		dictDefaultMessage: "Drag Images or Click Here to Upload",
		clickable: "#clickable",
		thumbnailHeight: 210,
		thumbnailWidth: null,
		previewTemplate: document.querySelector('#preview-template').innerHTML,
		previewsContainer: "#upload-previews"
	});

	// Update the total progress bar
	dropzone.on("totaluploadprogress", function(progress) {
	  $('.dz-upload').width = progress + "%";
	});

	dropzone.on("removedfile", function(file) {

	});

	dropzone.on("addedfile", function() {
		$(".dz-message, #clickable").hide();
	});

	dropzone.on("sending", function(file, xhr, formData) {
	  // Will send the content type along with the file as POST data.
	  console.log(file.type);
	  formData.append("Content-Type", file.type);
	});

  return dropzone.on("success", function(file, responseText) {
  	var direct_url = $(responseText).find("location")[0];
  	url_location = $(direct_url).text();

    $.post( "/uploads", { upload: {direct_upload_url: url_location} });
  });





};

$(document).ready(ready);
$(document).on('page:load', ready);