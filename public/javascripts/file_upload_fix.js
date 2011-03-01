$(document).ready(function(){
  var style_fix = '<div id="file_input_fix"><input type="text" name="file_fix" id="file_style_fix"></input><div id="browse_button">Browse...</div></div>';
  var take_photo_button = '<div id="take_a_photo">Take a photo</div>';
  $('#user_avatar_input').append(style_fix)
  //    .append(take_photo_button)
      .css("min-height", "54px");
  $('#user_avatar').change(function() {
    $("#file_input_fix input").val($(this).val().replace(/^.*\\/,""));
  });

  $('#user_avatar').css("opacity", 0);
  $('#user_avatar').css("z-index", 2); 
  $('#user_avatar').css("position", "absolute");
  $('#user_avatar').css("top", "25px");
  $('#user_avatar').css("height", "30px");
  
});
