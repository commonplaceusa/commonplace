
$(function() {
  $('#sign_in_button').click(function() {
    $(this).addClass("open");
    $("#new_user_session").slideDown(300);
  });
});