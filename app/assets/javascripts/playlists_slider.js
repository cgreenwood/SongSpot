$(document).ready(function() {
  $('.header').click(function(){
    if ($(this).next('.content').is(':visible')) {
      $(this).next('.content').slideUp();
    }
    else {
      $(this).next('.content').slideDown();
    }
  });
})
