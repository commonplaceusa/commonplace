$(function() {

  // all pages
  $('input[placeholder], textarea[placeholder]').placeholder();

  // Register
  $('#sign_in_button').click(function() {
    $(this).toggleClass("open");
    $(this).siblings("#sign_in_form").children("form").slideToggle();
  });

  // Add more info
  $("<div/>", { id: "file_input_fix" }).
    append($("<input/>", { type: "text", name: "file_fix", id: "file_style_fix" })).
    append($("<div/>", { id: "browse_button", text: "Browse..." })).
    appendTo("#user_avatar_input");
    
  
  $('#user_avatar').change(function() {
    $("#file_input_fix input").val($(this).val().replace(/^.*\\/,""));
  });
  
  $('#user_referral_source').change(function() {
    var selection = $("#user_referral_source option:selected").text();

    var new_label = {
      "At a table or booth at an event": "What was the event?",
      "In an email": "Who was the email from?",
      "On Facebook or Twitter": "From what person or organization?",
      "On another website": "What website?",
      "In the news": "From which news source?",
      "Word of mouth": "From what person or organization?",
      "Other": "Where?" }[selection];

    if (new_label) {
      $('#user_referral_metadata_input label').text(new_label);
      $('#user_referral_metadata_input').show('slow');
    }
  });

  // Avatar crop
  var updateCrop = function(coords) {
    $("#crop_x").val(coords.x);
    $("#crop_y").val(coords.y);
    $("#crop_w").val(coords.w);
    $("#crop_h").val(coords.h);
  };

  $("#cropbox").Jcrop({
    onChange: updateCrop,
    onSelect: updateCrop,
    aspectRatio: 1.0,
    boxWidth: 600
  });

  // add feeds and add groups
  $('.add_groups .group, .add_feeds .feed').click(function(){
    $('div', this).toggleClass('checked');
    var $checkbox = $("input:checkbox", this);
    $checkbox.attr("checked", 
                   $checkbox.is(":checked") ? false : "checked");
  });

});
