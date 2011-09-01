$(function() {
  $("<div/>", { id: "file_input_fix" }).
    append($("<input/>", { type: "text", name: "file_fix", id: "file_style_fix" })).
    append($("<div/>", { id: "browse_button", text: "Browse..." })).
    appendTo("#feed_avatar_input");
  

  $('#feed_avatar').change(function() {
    $("#file_input_fix input").val($(this).val().replace(/^.*\\/,""));
  });
});