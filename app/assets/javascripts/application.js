// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.readyselector.js
//= require turbolinks
//= require dropzone
//= require jquery.Jcrop
//= require_tree .

function formatTags(tag_input_field) {
	  deleteNextIteration = true;

    $(tag_input_field).on('focusout',function(){    
      var txt= this.value.replace(/[^a-zA-Z0-9\+\-\.\#\s]/g,''); // allowed characters
      if(txt) {
        $(this).before('<span class="temporary tag"><span class="tag-data">'+ txt.toLowerCase() + '</span>' + '<span class="delete-tag fa fa-remove"></span></span>');
      }
      this.value="";
      }).on('keyup',function( e ){
      	checkEnter(e);
	      // if: comma,enter (delimit more keyCodes with | pipe)
	      if(/(188|13)/.test(e.which)) {
	        $(this).focusout();
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
  };

  function getTags( tags ) {
    var a = [];
    for ( var i = 0; i < tags.length; i++ ) {
      a.push( tags[ i ].textContent );
    }
    return a.join();
  }

  function checkEnter(e){
		 e = e || event;
		 var txtArea = /textarea/i.test((e.target || e.srcElement).tagName);
		 return txtArea || (e.keyCode || e.which || e.charCode || 0) !== 13;
		}