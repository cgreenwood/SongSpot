$(document).on('turbolinks:load',(function() {
  console.log("File loaded");
  $('.header').on('click', function() {
    if ($(this).next('.content').is(':visible')) {
      $(this).next('.content').slideUp();
    } else {
      $(this).next('.content').slideDown();
    }
  });
}));
