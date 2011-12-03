//= require slugify.js
//= require jquery.js
//= require jcrop.js

$(function() {
  $("<div/>", { id: "file_input_fix" })
    .append($("<div/>", { id: "browse_button", text: "Browse..." }))
    .appendTo("#feed_avatar_input");
  
  $("#feed_slug_input").data("original-hint", 
                             $("#feed_slug_input p.inline-hints").html());

  $("#feed_name").keyup(function() {
    if (!$("#feed_slug").data("manual")) {
      $("#feed_slug").val(slugify($(this).val()));
      $("#feed_slug_input p.inline-hints").html(
        $("#feed_slug_input").data("original-hint").replace(/____/g,
                                                            $("#feed_slug").val()));
    }
  });
  
  $("#feed_slug").keydown(function() {
    $(this).data("manual", true);
  });

  $("#feed_slug").focusin(function() {
    $("#feed_slug_input p.inline-hints").show();
  });

  $("#feed_slug").keyup(function() {
    $("#feed_slug_input p.inline-hints").html(
      $("#feed_slug_input").data("original-hint").replace(/____/g,
                                                          $("#feed_slug").val()));
  });

  $("#feed_slug").focusout(function() {
    $("#feed_slug_input p.inline-hints").hide();
  });
  
  // Avatar crop
  var updateCrop = function(coords) {
    $("#crop_x").val(coords.x);
    $("#crop_y").val(coords.y);
    $("#crop_w").val(coords.w);
    $("#crop_h").val(coords.h);
  };

  $("form.crop").load(function() {
    $("form.crop").css({ width: Math.max($("#cropbox").width(), 420) });
  });

  $("#cropbox").Jcrop({
    onChange: updateCrop,
    onSelect: updateCrop,
    aspectRatio: 1.0
  });

  $("form.new_subscribers td").focusin(function() {
    if ($(this).text() == "...") { $(this).text(""); }
  });

  $("form.new_subscribers td").focusout(function() {
    if ($(this).text() == "") { $(this).text("..."); }
  });

  $("form.new_subscribers").submit(function(e) {
    var subscribers = [];
    $("form.new_subscribers .input-row").each(function() {
      var name = $(".name", this).text();
      var email = $(".email", this).text();
      if ((name != "") && (name != "...") && (email != "") && (email != "...")) {
        var val =  name + "<" + email + ">";
        $('<input type="hidden" name="feed_subscribers[]">').val(val).appendTo($("form.new_subscribers"));
      }
    });
    
  });

  
});
