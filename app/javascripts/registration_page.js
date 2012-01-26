//= require jquery
//= require placeholder
//= require jcrop
//= require chosen

$(function() {

  // all pages
  $('input[placeholder], textarea[placeholder]').placeholder();

  // Register
  $('#sign_in_button').click(function() {
    $(this).toggleClass("open");
    $(this).siblings("#sign_in_form").children("form").slideToggle();
  });

  // Add more info
  $("#user_interest_list, #user_good_list, #user_skill_list").chosen();

  $("<div/>", { id: "file_input_fix" })
    .append($("<input/>", { type: "text", name: "file_fix", id: "file_style_fix" }))
    .append($("<div/>", { id: "browse_button", text: "Browse..." }))
    .appendTo("#user_avatar_input");
    
  
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
    var $img = $("img#cropbox");
    var scale = $img[0].width / $img.width();
    if (scale) {
      $("#crop_x").val(coords.x * scale);
      $("#crop_y").val(coords.y * scale);
      $("#crop_w").val(coords.w * scale);
      $("#crop_h").val(coords.h * scale);
    }
  };

  $("form.crop img").load(function() {
    var $img = $("form.crop img");
    var scale = Math.max(
      380 / $img.width(),
      320 / $img.height()
    );
    $("form.crop").css({
      width: Math.floor($img.width() * scale),
      height: Math.floor( ($img.height() * scale) + 50)
    });
    $img.css({
      width:  Math.floor($img.width()  * scale),
      height: Math.floor($img.height() * scale)
    });
    $img.Jcrop({
      onChange: updateCrop,
      onSelect: updateCrop,
      aspectRatio: 1.0
    });
  });


  // add feeds and add groups
  $('.add_groups .group, .add_feeds .feed').click(function(){
    $('div', this).toggleClass('checked');
    var $checkbox = $("input:checkbox", this);
    $checkbox.attr("checked", 
                   $checkbox.is(":checked") ? false : "checked");
  });

});
