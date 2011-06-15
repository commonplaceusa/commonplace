var CommonPlace = CommonPlace || {};
function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
    callback = data;
    data = {};
  }
  return jQuery.ajax({
    type: method,
    url: url,
    data: data,
    success: callback,
    dataType: type
  });
}

jQuery.extend({
  put: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'PUT');
  },
  del: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'DELETE');
  }
});



CommonPlace.render = function(name, params) {
  return Mustache.to_html(
    CommonPlace.templates[name],
    _.extend({auth_token: CommonPlace.auth_token,
              account_avatar_url: CommonPlace.account.get('avatar_url')},
             params),
    CommonPlace.templates);
};

Mustache.template = function(templateString) {
  return templateString;
};


$.preLoadImages("/images/loading.gif");

CommonPlace.linkify = function(text) {
  var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i;
  return text.replace(exp,"<a href='$1'>$1</a>"); 
}

CommonPlace.timeAgoInWords = function(date_str) {
  var time = CommonPlace.parseDate(date_str);
  var diff_in_seconds = (time - (new Date)) / 1000;
  var diff_in_minutes = Math.abs(Math.floor((diff_in_seconds / 60)));
  var add_token = function (in_words) { return diff_in_seconds > 0 ? "in " + in_words : in_words + " ago"; };
  if (diff_in_minutes === 0) { return add_token('less than a minute'); }
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

CommonPlace.parseDate = function(date_str) {
  var m = date_str.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z/);
  return Date.UTC(m[1],m[2] - 1,m[3],m[4],m[5],m[6]);
};


$(function() {



  $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function() {
      $("#preview").find("[data-track='" + $input.attr('name') + "']").html($input.val());
    }, 10);
  });

  $('#sign_in_button').click(function() {
    $(this).addClass("open");
    $("form.user_session").slideDown(300);
  });


  $(window).bind('resize.modal', function () {
    var $m = $("#modal-content");
    if ($m.get(0)) {
      var w = $m.width(),
      h = $m.height(),
      $b = $(window),
      bw = $b.width(),
      bh = $b.height();
      
      $m.css({top: (bh - h) / 2, left: (bw - w) / 2 - 20});
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
    

    setInfoBoxPosition();    
    
    $("#file_uploader").change(function() {
      $(this).trigger('image.inline-form');
    });

  });

  $("body").trigger("#information");


  // Feed Profile
  $('#post-to-feed h2 nav li:last-child').hide();
  $('#post-to-feed h2 nav ul').hover(function(){
    $('#post-to-feed h2 nav li:last-child').show();
  }, function(){
    $('#post-to-feed h2 nav li:last-child').hide();	
  });


  // Accounts
  //Does the who is bubble stuff
  $('#who_is_info_bubble h3').click(function(){
    var re = new RegExp(/blue-arrow-down/);
    if($('#who_is_info_bubble h3.toggle').css("background-image").match(re)) {
      $('#who_is_info_bubble h3.toggle').css("background-image","url(/images/blue-arrow-up.png)");
    } else  {
      $('#who_is_info_bubble h3.toggle').css("background-image","");
    }
    	$('#who_is_info').slideToggle();
  });

  //Tool tips for main page:
//  $('#user_address').tipsy({delayIn: 1000, delayOut: 1000, fade: true, gravity: 'n', trigger: 'focus', live: true, offset: -20 ,fallback: "We need your address so we can place you in a neighborhood within Falls Church!"});
  
  //Style fix for the photoupload stuff

  var style_fix = '<div id="file_input_fix"><input type="text" name="file_fix" id="file_style_fix"></input><div id="browse_button">Browse...</div></div>';
  var take_photo_button = '<div id="take_a_photo" onClick="load_modal();">Take a photo</div>';
  $('.edit_new #user_avatar_input').append(style_fix).css("min-height", "54px");
  
  $('.edit_new #user_avatar').
    css("opacity", 0).
    css("z-index", 2).
    css("position", "absolute").
    css("top", "25px").
    css("height", "30px");
  
  $('.edit_new #user_avatar').change(function() {
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
/*!
 * JavaScript Linkify - v0.3 - 6/27/2009
 * http://benalman.com/projects/javascript-linkify/
 * 
 * Copyright (c) 2009 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 * 
 * Some regexps adapted from http://userscripts.org/scripts/review/7122
 */

// Script: JavaScript Linkify: Process links in text!
//
// *Version: 0.3, Last updated: 6/27/2009*
// 
// Project Home - http://benalman.com/projects/javascript-linkify/
// GitHub       - http://github.com/cowboy/javascript-linkify/
// Source       - http://github.com/cowboy/javascript-linkify/raw/master/ba-linkify.js
// (Minified)   - http://github.com/cowboy/javascript-linkify/raw/master/ba-linkify.min.js (2.8kb)
// 
// About: License
// 
// Copyright (c) 2009 "Cowboy" Ben Alman,
// Dual licensed under the MIT and GPL licenses.
// http://benalman.com/about/license/
// 
// About: Examples
// 
// This working example, complete with fully commented code, illustrates one way
// in which this code can be used.
// 
// Linkify - http://benalman.com/code/projects/javascript-linkify/examples/linkify/
// 
// About: Support and Testing
// 
// Information about what browsers this code has been tested in.
// 
// Browsers Tested - Internet Explorer 6-8, Firefox 2-3.7, Safari 3-4, Chrome, Opera 9.6-10.
// 
// About: Release History
// 
// 0.3 - (6/27/2009) Initial release

// Function: linkify
// 
// Turn text into linkified html.
// 
// Usage:
// 
//  > var html = linkify( text [, options ] );
// 
// Arguments:
// 
//  text - (String) Non-HTML text containing links to be parsed.
//  options - (Object) An optional object containing linkify parse options.
// 
// Options:
// 
//  callback (Function) - If specified, this will be called once for each link-
//    or non-link-chunk with two arguments, text and href. If the chunk is
//    non-link, href will be omitted. If unspecified, the default linkification
//    callback is used.
//  punct_regexp (RegExp) - A RegExp that will be used to trim trailing
//    punctuation from links, instead of the default. If set to null, trailing
//    punctuation will not be trimmed.
// 
// Returns:
// 
//  (String) An HTML string containing links.

window.linkify = (function(){
  var
  SCHEME = "[a-z\\d.-]+://",
  IPV4 = "(?:(?:[0-9]|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.){3}(?:[0-9]|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])",
  HOSTNAME = "(?:(?:[^\\s!@#$%^&*()_=+[\\]{}\\\\|;:'\",.<>/?]+)\\.)+",
  TLD = "(?:ac|ad|aero|ae|af|ag|ai|al|am|an|ao|aq|arpa|ar|asia|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|biz|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|cat|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|coop|com|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|edu|ee|eg|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gov|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|info|int|in|io|iq|ir|is|it|je|jm|jobs|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mil|mk|ml|mm|mn|mobi|mo|mp|mq|mr|ms|mt|museum|mu|mv|mw|mx|my|mz|name|na|nc|net|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|org|pa|pe|pf|pg|ph|pk|pl|pm|pn|pro|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tel|tf|tg|th|tj|tk|tl|tm|tn|to|tp|travel|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|xn--0zwm56d|xn--11b5bs3a9aj6g|xn--80akhbyknj4f|xn--9t4b11yi5a|xn--deba0ad|xn--g6w251d|xn--hgbk6aj7f53bba|xn--hlcj6aya9esc7a|xn--jxalpdlp|xn--kgbechtv|xn--zckzah|ye|yt|yu|za|zm|zw)",
  HOST_OR_IP = "(?:" + HOSTNAME + TLD + "|" + IPV4 + ")",
  PATH = "(?:[;/][^#?<>\\s]*)?",
  QUERY_FRAG = "(?:\\?[^#<>\\s]*)?(?:#[^<>\\s]*)?",
  URI1 = "\\b" + SCHEME + "[^<>\\s]+",
  URI2 = "\\b" + HOST_OR_IP + PATH + QUERY_FRAG + "(?!\\w)",
    
  MAILTO = "mailto:",
  EMAIL = "(?:" + MAILTO + ")?[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@" + HOST_OR_IP + QUERY_FRAG + "(?!\\w)",
    
  URI_RE = new RegExp( "(?:" + URI1 + "|" + URI2 + "|" + EMAIL + ")", "ig" ),
  SCHEME_RE = new RegExp( "^" + SCHEME, "i" ),
    
  quotes = {
    "'": "`",
    '>': '<',
    ')': '(',
    ']': '[',
    '}': '{',
    'Â»': 'Â«',
    'â€º': 'â€¹'
  },
    
  default_options = {
    callback: function( text, href ) {
      return href ? '<a href="' + href + '" title="' + href + '">' + text + '</a>' : text;
    },
    punct_regexp: /(?:[!?.,:;'"]|(?:&|&amp;)(?:lt|gt|quot|apos|raquo|laquo|rsaquo|lsaquo);)$/
    };
  
  return function( txt, options ) {
    options = options || {};
    
    // Temp variables.
    var arr,
      i,
      link,
      href,
      
      // Output HTML.
      html = '',
      
      // Store text / link parts, in order, for re-combination.
      parts = [],
      
      // Used for keeping track of indices in the text.
      idx_prev,
      idx_last,
      idx,
      link_last,
      
      // Used for trimming trailing punctuation and quotes from links.
      matches_begin,
      matches_end,
      quote_begin,
      quote_end;
    
    // Initialize options.
    for ( i in default_options ) {
      if ( options[ i ] === undefined ) {
        options[ i ] = default_options[ i ];
      }
    }
    
    // Find links.
    while ( arr = URI_RE.exec( txt ) ) {
      
      link = arr[0];
      idx_last = URI_RE.lastIndex;
      idx = idx_last - link.length;
      
      // Not a link if preceded by certain characters.
      if ( /[\/:]/.test( txt.charAt( idx - 1 ) ) ) {
        continue;
      }
      
      // Trim trailing punctuation.
      do {
        // If no changes are made, we don't want to loop forever!
                       link_last = link;
        
                       quote_end = link.substr( -1 )
                       quote_begin = quotes[ quote_end ];
        
        // Ending quote character?
                       if ( quote_begin ) {
                         matches_begin = link.match( new RegExp( '\\' + quote_begin + '(?!$)', 'g' ) );
                         matches_end = link.match( new RegExp( '\\' + quote_end, 'g' ) );
          
          // If quotes are unbalanced, remove trailing quote character.
                         if ( ( matches_begin ? matches_begin.length : 0 ) < ( matches_end ? matches_end.length : 0 ) ) {
                           link = link.substr( 0, link.length - 1 );
                           idx_last--;
                         }
                       }
        
        // Ending non-quote punctuation character?
                       if ( options.punct_regexp ) {
                         link = link.replace( options.punct_regexp, function(a){
                           idx_last -= a.length;
                           return '';
                         });
                       }
                      } while ( link.length && link !== link_last );
      
                    href = link;
      
      // Add appropriate protocol to naked links.
                    if ( !SCHEME_RE.test( href ) ) {
                      href = ( href.indexOf( '@' ) !== -1 ? ( !href.indexOf( MAILTO ) ? '' : MAILTO )
                               : !href.indexOf( 'irc.' ) ? 'irc://'
                               : !href.indexOf( 'ftp.' ) ? 'ftp://'
                               : 'http://' )
                        + href;
                    }
      
      // Push preceding non-link text onto the array.
                    if ( idx_prev != idx ) {
                      parts.push([ txt.slice( idx_prev, idx ) ]);
                      idx_prev = idx_last;
                    }
      
      // Push massaged link onto the array
                    parts.push([ link, href ]);
                   };
    
    // Push remaining non-link text onto the array.
    parts.push([ txt.substr( idx_prev ) ]);
    
    // Process the array items.
    for ( i = 0; i < parts.length; i++ ) {
      html += options.callback.apply( window, parts[i] );
    }
    
    // In case of catastrophic failure, return the original text;
    return html || txt;
  };
  
})();