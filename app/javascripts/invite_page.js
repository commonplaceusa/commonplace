//= require_tree ./shared
function onABCommComplete() {
  text = "";
  $($("textarea#invite_email").val().split(", "))
    .each(function(index, value) { text += value.replace(/(.*)<(.*)>/, "$2") + ", "; });
  $("textarea#invite_email").val(text.substring(0, text.length-2));
}



function add_to_friends_of_commonplace(email) {
  $.post('/account/make_focp', 'email=' + email);
}


$(function(){

  $('input[placeholder], textarea[placeholder]').placeholder();
  $('textarea').autoResize();

  $("#invite_email_input").removeClass("optional");
  $("#invite_body_input").removeClass("optional");
  $("#invite_email_input").addClass("required");
  $("#invite_body_input").removeClass("required");

  $("form#new_invite").submit(function(e) {
    e.preventDefault();
    $.ajax({
      type: "POST",
      dataType: "json",
      url: $(this).attr("action"),
      data: JSON.stringify({
        emails: $("#invite_email", this).val().split(/,\s*/),
        message: $("#invite_body", this).val()
      }),
      success: function() {
        $("#new_invite #invite_email").val("");
        $("#new_invite #invite_body").val("");
        $("form#new_invite").append($('<p class="confirm" ' +
                                      'style="color: white; ' +
                                      'margin: 15px auto 0; ' +
                                      'text-align: center;">' +
                                      'Invites sent. Send some more!'+
                                      '</p>'));        
      }

    });
  });

});
