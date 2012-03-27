//= require jquery
//= require json2
//= require dropkick

$(function() {
  $('#sign_in_button').click(function() {
    $("#header #sign_in_form").toggle();
  });
  $("#sign_in_form form input.submit").click(function(e) {
    if (e) { e.preventDefault(e); }
    $("#sign_in_form #errors").html("");
    $("#sign_in_form .error").removeClass("error");

    var email = $("#sign_in_form input[name=email]").val();
    if (!email) {
      $("#sign_in_form #errors").append();
      $("#sign_in_form label[name=email]").addClass("error");
      return false;
    }

    var password = $("#sign_in_form input[name=password]").val();
    if (!password) {
      $("#sign_in_form #errors").append();
      $("#sign_in_form label[name=password]").addClass("error");
      return false;
    }

    $.post({
      url: "/api/sessions",
      data: JSON.stringify({ email: email, password: password }),
      success: function() {
        console.log("Success");
        document.location.reload();
      },
      error: function() {
        console.log("Error");
        $("#sign_in_form #errors").append("<li class='error'>Invalid login! Please try again.</li>");
        $("#sign_in_form label").addClass("error");
      },
      dataType: "json"
    });
    console.log("Got here");
    return false;
  });
});
