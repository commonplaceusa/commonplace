var CommonPlace = CommonPlace || {};

Mustache.template = function(templateString) {
  return templateString;
};

CommonPlace.timeAgoInWords = function(date_str) {
  var m = date_str.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/);
  var time = Date.UTC(m[1],m[2] - 1,m[3],m[4],m[5],m[6]);
  var diff_in_seconds = (time - Date.now()) / 1000;
  var diff_in_minutes = Math.abs(Math.floor((diff_in_seconds / 60)));
  var add_token = function (in_words) { return diff_in_seconds > 0 ? "in " + in_words : in_words + " ago"; };
  if (diff_in_minutes == 0) { return add_token('less than a minute'); }
  if (diff_in_minutes == 1) { return add_token('a minute'); }
  if (diff_in_minutes < 45) { return add_token(diff_in_minutes + ' minutes'); }
  if (diff_in_minutes < 90) { return add_token('about 1 hour'); }
  if (diff_in_minutes < 1440) { return add_token('about ' + Math.floor(diff_in_minutes / 60) + ' hours'); }
  if (diff_in_minutes < 2880) { return add_token('1 day'); }
  if (diff_in_minutes < 43200) { return add_token(Math.floor(diff_in_minutes / 1440) + ' days'); }
  if (diff_in_minutes < 86400) { return add_token('about 1 month'); }
  if (diff_in_minutes < 525960) { return add_token(Math.floor(diff_in_minutes / 43200) + ' months'); }
  if (diff_in_minutes < 1051199) { return add_token('about 1 year'); }
  
  return add_token('over ' + Math.floor(diff_in_minutes / 525960) + ' years');
};


$(function() {
  $.preLoadImages("/images/loading.gif");


  $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function() {
      $("#preview")
        .find("[data-track='" + $input.attr('name') + "']")
        .html($input.val());
    }, 10);
  });

  $('a.new_subscription').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.post($(that).attr('href'), function(response) {
      if (response) {
        var $response = $(window.innerShiv(response,false));
        $("#information").replaceWith($response.filter("#information"));
        var $newitem = $response.filter('div.item_div');
        $("#" + $newitem.attr('id')).replaceWith($newitem);
      }
    });
  });

  $('a.unsubscribe').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.ajax({
      type: "DELETE",
      url: $(that).attr('href'),
      success: function(response) {
        if (response) {
          var $response = $(window.innerShiv(response,false));
          $("#information").replaceWith($response.filter("#information"));
          var $newitem = $response.filter('div.item_div');
          $("#" + $newitem.attr('id')).replaceWith($newitem);
        }

      }
    });
  });

  $('a.message_me').live('click', function(e) {
    e.preventDefault();
    var that = this;
    $.get($(that).attr('href'),
          function(response) {
            if (response) {
              $("#modal").replaceWith(
                $(window.innerShiv(response,false)).filter("#modal")
              );
              $(window).trigger('resize.modal');
            }
          });

  });

  $('form.message').live('submit',
                         function(e) {
                           e.preventDefault();
                           var that = this;
                           $.post($(that).attr('action'), $(that).serialize(),
                                  function(response) {
                                    if (response) {
                                      $("#modal").replaceWith(window.innerShiv(response,false));
                                    }
                                    $(window).trigger('resize.modal');
                                  });
                         });


  $('#sign_in_button').click(function() {
    $(this).addClass("open");
    $("form.user_session").slideDown(300);
  });


  $(window).bind('resize.modal', function () {
    var $m = $("#modal-content")
    if ($m.get(0)) {
      var w = $m.width(),
      h = $m.height(),
      $b = $(window),
      bw = $b.width(),
      bh = $b.height();
      
      $m.css({top: (bh - h) / 2,
              left: (bw - w) / 2 - 20
             });
    }
  });

  $("#modal-close").live('click', function(e) {
    $("#modal").html("");
    e.preventDefault();
  });

  $("body").bind("#modal", function(e, content) {
    if (content) {
      $("#modal").replaceWith(window.innerShiv(content, false));
    }
   $(window).trigger('resize.modal');
   setTimeout(function(){$(window).trigger("resize.modal");}, 500);
  });

  $("body").trigger("#modal");


  var didscroll = false;  
  $(window).scroll(function() { didscroll = true; });

  setInterval(function() {
    if (didscroll) {
      didscroll = false;
      setInfoBoxPosition();
    }
  }, 100); 
    

  $("body").bind("#information", function(e, content) {
    if (content) {
      $("#information").replaceWith(window.innerShiv(content, false));
    }
    
    renderMaps();    
    
    setInfoBoxPosition();    
    
    $("#file_uploader").change(function() {
      $(this).trigger('image.inline-form');
    });

    initInlineForm();

  });

  $("body").trigger("#information");


  // Feed Profile
  $('#post-to-feed h2 nav li:last-child').hide();
  $('#post-to-feed h2 nav ul').hover(function(){
    $('#post-to-feed h2 nav li:last-child').show();
  }, function(){
    $('#post-to-feed h2 nav li:last-child').hide();	
  })


  // Accounts
  //Does the who is bubble stuff
  $('#who_is_info_bubble h3').click(function(){
    var re = new RegExp(/blue-arrow-down/)
    if($('#who_is_info_bubble h3.toggle').css("background-image").match(re)){
      $('#who_is_info_bubble h3.toggle').css("background-image","url(/images/blue-arrow-up.png)")
    }
    else{
      $('#who_is_info_bubble h3.toggle').css("background-image","") 
    }
    	$('#who_is_info').slideToggle();
  });

  //Tool tips for main page:
//  $('#user_address').tipsy({delayIn: 1000, delayOut: 1000, fade: true, gravity: 'n', trigger: 'focus', live: true, offset: -20 ,fallback: "We need your address so we can place you in a neighborhood within Falls Church!"});
  
  //Style fix for the photoupload stuff
  var style_fix = '<div id="file_input_fix"><input type="text" name="file_fix" id="file_style_fix"></input><div id="browse_button">Browse...</div></div>';
  var take_photo_button = '<div id="take_a_photo" onClick="load_modal();">Take a photo</div>';
	$('#user_avatar_input').append(style_fix)
  // .append(take_photo_button)
    .css("min-height", "54px");
  
	$('#user_avatar').css("opacity", 0);
	$('#user_avatar').css("z-index", 2); 
	$('#user_avatar').css("position", "absolute")
	$('#user_avatar').css("top", "25px")
	$('#user_avatar').css("height", "30px");

  $('#user_avatar').change(function() {
    $("#file_input_fix input").val($(this).val().replace(/^.*\\/,""));
  });
  
  
  // accounts/add_feeds
  $('.add_groups .group, .add_feeds .feed').click(function(){
    $('div', this).toggleClass('checked');
    var $checkbox = $("input:checkbox", this);
    $checkbox.attr("checked", 
                   $checkbox.is(":checked") ? false : "checked");
  });
});
