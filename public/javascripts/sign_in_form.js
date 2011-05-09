
$(function() {
  $('#sign_in_button').click(function() {
    $(this).addClass("open");
    $("form.user_session").slideDown(300);
  });
});