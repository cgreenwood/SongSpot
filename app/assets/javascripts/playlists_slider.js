$(document).ready(function() {
  console.log("File loaded");
  $('.header').click(function(){
    if ($(this).next('.content').is(':visible')) {
      $(this).next('.content').slideUp();
    }
    else {
      $(this).next('.content').slideDown();
    }
  });
})
