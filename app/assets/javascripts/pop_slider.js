$(document).on('turbolinks:load', function() {
  $('#min_pop').change(function() {
    $('#pop-value').html('Current Value is : ' + $('#min_pop').val());
  })
})
