var ready;
ready = function() {

 	// disable auto discover
	Dropzone.autoDiscover = false;

	$('.dropzone').hover(function() {
        $(this).css('cursor','pointer');
    });
 

	var dropzone = new Dropzone(document.body, {
		maxFilesize: 50, // Set the maximum file size to 50 MB
		paramName: "upload[image]", // Rails expects the file upload to be something like model[field_name]
		addRemoveLinks: true, // Don't show remove links on dropzone itself.
		acceptedFiles: 'image/*',
		dictDefaultMessage: "Drag Images or Click Here to Upload",
		previewsContainer: null,
		clickable: "#upload-btn",
		thumbnail-height: 210,
		previewTemplate: document.querySelector('preview-template').innerHTML,
	});

	// Update the total progress bar
	dropzone.on("totaluploadprogress", function(progress) {
	  $('.dz-upload').width = progress + "%";
	});

};

$(document).ready(ready)
$(document).on('page:load', ready)