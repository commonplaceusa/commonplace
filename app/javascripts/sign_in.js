//= require jquery.1.7

$(function() {
  $('#sign_in_button').click(function() {
    $(this).toggleClass("open");
    $(this).siblings("#sign_in_form").children("form").toggle();
  });
});