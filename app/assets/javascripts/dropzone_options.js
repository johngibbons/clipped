var ready;
ready = function() {

 	// disable auto discover
	Dropzone.autoDiscover = false;

	$('.dropzone').hover(function() {
        $(this).css('cursor','pointer');
    });
 

	var dropzone = new Dropzone (".dropzone", {
		maxFilesize: 50, // Set the maximum file size to 256 MB
		paramName: "upload[image]", // Rails expects the file upload to be something like model[field_name]
		addRemoveLinks: false, // Don't show remove links on dropzone itself.
		acceptedFiles: 'image/*',
		dictDefaultMessage: "Drag Images or Click Here to Upload"
	});	

	dropzone.on("success", function(file) {
		this.removeFile(file)
		$.getScript("/uploads")
	})

	// Update the total progress bar
	dropzone.on("totaluploadprogress", function(progress) {
	  $('.dz-upload').width = progress + "%";
	});

};

$(document).ready(ready)
$(document).on('page:load', ready)