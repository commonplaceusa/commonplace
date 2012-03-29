//= require jquery

$(function() {
  $('#sign_in_button').click(function() {
    $(this).toggleClass("open");
    $(this).siblings("#sign_in_form").children("form").toggle();
  });
});