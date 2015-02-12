var ready;
ready = function() {

 	// disable auto discover
	Dropzone.autoDiscover = false;

 	var dropzone = new Dropzone( ".dropzone", {
		maxFilesize: 50, // Set the maximum file size to 50 MB
		paramName: "upload[image]", // Rails expects the file upload to be something like model[field_name]
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

};

$(document).ready(ready)
$(document).on('page:load', ready)