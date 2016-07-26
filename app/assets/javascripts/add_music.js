function add_music(id) {
  $.ajax ({
    url: '/add_track_to_your_music',
    type: 'POST',
    data: {id: id},
    datatype: 'JSON',
    success: function(data, status, xhr) {
      var name = ('#' + id);
      console.log(name);
      $(name).attr("value", "Done");
      $(name).attr("disabled", "disabled")
      console.log("success")
    }
  });
}
//* <i class="fa fa-check" aria-hidden="true"></i>
