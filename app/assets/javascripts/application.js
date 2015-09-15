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

$(document).ready(function(){
  Turbolinks.enableProgressBar();

  if ($(".modal").length) {
    $(".modal").each(function(){
      $(this).find(".modal-state").on("change", function(){
        if ($(this).is(":checked")) {
          $(".modal-inner").addClass("animated slideInUp").css("display", "block");
          $("body").addClass(".modal-open");
        } else {
          $("body").removeClass(".modal-open");
        }
      });
    });

    $(".modal-close, .modal-fade-screen").on("click", function() {
      $(".modal-inner").removeClass("slideInUp").addClass("slideOutDown");
      $(".modal-state:checked").prop("checked", false).change();
      setTimeout(function(){
        $(".modal-inner").removeClass("slideOutDown").addClass("slideInUp").css("display", "none");
      }, 300);
    });

    $(".modal-inner").on("click", function(e) {
      e.stopPropagation();
    });
  }

  $("body").on("click", ".tooltip-item", function(){
    $(this).find(".tooltip").toggleClass("hidden");
  });

});

