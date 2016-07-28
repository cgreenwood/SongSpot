$(document).on('turbolinks:load', function() {
  $('#limit').change(function() {
    $('#limit-value').html('Current Value is : ' + $('#limit').val());
  })
})
