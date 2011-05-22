var CommonPlace = CommonPlace || {};

Mustache.template = function(templateString) {
  return templateString;
};

CommonPlace.time_formats = [
  [60, 'just now', 1], // 60
  [120, '1 minute ago', '1 minute from now'], // 60*2
  [3600, 'minutes', 60], // 60*60, 60
  [7200, '1 hour ago', '1 hour from now'], // 60*60*2
  [86400, 'hours', 3600], // 60*60*24, 60*60
  [172800, 'yesterday', 'tomorrow'], // 60*60*24*2
  [604800, 'days', 86400], // 60*60*24*7, 60*60*24
  [1209600, 'last week', 'next week'], // 60*60*24*7*4*2
  [2419200, 'weeks', 604800], // 60*60*24*7*4, 60*60*24*7
  [4838400, 'last month', 'next month'], // 60*60*24*7*4*2
  [29030400, 'months', 2419200], // 60*60*24*7*4*12, 60*60*24*7*4
  [58060800, 'last year', 'next year'], // 60*60*24*7*4*12*2
  [2903040000, 'years', 29030400], // 60*60*24*7*4*12*100, 60*60*24*7*4*12
  [5806080000, 'last century', 'next century'], // 60*60*24*7*4*12*100*2
  [58060800000, 'centuries', 2903040000] // 60*60*24*7*4*12*100*20, 60*60*24*7*4*12*100
];

CommonPlace.formatDate = function(date_str) {
  var time = ('' + date_str).replace(/-/g,"/").replace(/[TZ]/g," ");
  var seconds = (new Date - new Date(time)) / 1000 + (new Date).getTimezoneOffset() * 60;
  var token = 'ago', list_choice = 1;
  if (seconds < 0) {
    seconds = Math.abs(seconds);
    token = 'from now';
    list_choice = 2;
  }
  var i = 0, format;
  while (format = CommonPlace.time_formats[i++]) if (seconds < format[0]) {
    if (typeof format[2] == 'string')
      return format[list_choice];
    else
      return Math.floor(seconds / format[2]) + ' ' + format[1] + ' ' + token;
  }
  return time;
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
