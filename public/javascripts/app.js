
if (window.location.hash.slice(1) != "") {
  window.location = window.location.hash.slice(1);
}

$(function() {
  
  HOST_HREF_REGEX = new RegExp("^" + window.location.protocol + "//" + window.location.host);


  $.preLoadImages("/images/loading.gif");

  $('a[data-remote]').live('click', function(e) {
    e.preventDefault();
    var path = $(this).attr('href').replace(HOST_HREF_REGEX, ""),
    method = $(this).attr('data-method') || "get";
    ajaj(method, path, null);
    if (method == "get") {
      window.location.hash = path;
    }
  });
  
  $('div[data-href]').live('click', function(e) {
    e.preventDefault();
    ajaj("get", $(this).attr('data-href'), null);
    window.location.hash = $(this).attr('data-href');
  });
  
  $('div[data-href] a').live('click', function(e) {
    e.stopPropagation();
  });

  $('div[data-href] input, div[data-href] button').live('click', function(e) {
    e.stopPropagation();
  });

  $('form[data-remote]').live('submit', function(e) {
    $('input[type=image]',$(this))
      .replaceWith('<img style="float: right"src="/images/loading.gif">');
    e.preventDefault();
    ajaj("post", $(this).attr('action'), $(this).serialize());
  });

  $("body").bind("redirect_to", function(e, url) {
    if (url.match(/^https?:/)) {
      window.location = url;
    } else {
      window.location.hash = url;
      ajaj("get", url, null);
    }
  });

  // TODO: remove legacy support for update_content
  // migration to trigger
  $.each(
    ["#say-something","#tooltip", "#main", "#new_feed", 
     "#post-to-feed", "#recent-posts", "#zones", "#deliveries"],
    function(i, selector) {
      $("body").bind(selector, function(event, content) {
        if (content) {
          $(selector).replaceWith(window.innerShiv(content, false));
        }             
      });
    });
  

  $("body").bind("#deliveries", function(e, content) {
    $("#deliveries").replaceWith(window.innerShiv(content, false));

    $("#deliveries").click(function() {
      $("#deliveries ul").slideToggle();
    });
  });  

  $("body").bind("always", function(e) {
    $('input[placeholder], textarea[placeholder]').placeholder();
    
    showTooltips();
    
    $('input.date').datepicker({
      prevText: '&laquo;',
      nextText: '&raquo;',
      showOtherMonths: true,
      defaultDate: null
    });
    
    
    
    $('#tooltip').html($('#tooltip').attr('title'));
    
    
    $('.disabled_link, a[href=disabled]').attr('title', "Coming soon!").tipsy({gravity: 'n'});
    
    
    $.polygonInputs();
    
    $('form.formtastic.user input:text, form.formtastic.user textarea').keydown(function(e) {
      var $input = $(e.currentTarget);
        setTimeout(function(){
          $("#preview")
            .find("[data-track='" + $input.attr('name') + "']")
            .html($input.val());
        }, 10);
    });
    
    $('form.formtastic.feed input:text, form.formtastic.feed textarea').keydown(function(e) {
      var $input = $(e.currentTarget);
        setTimeout(function() {
          $("#preview")
            .find("[data-track='" + $input.attr('name') + "']")
            .html($input.val());
        }, 10);
    });
  });


  $("body")
    .trigger("always")

  
  $("body").bind("replace-with", function(e, params) {
    $(params.selector).replaceWith(params.content);
  });




});

function ajaj(method, path, data) {
  $.ajax({
    type: method,
    url: path,
    data: data,
    dataType: "json",
    success: function(response) {
      if (response) {
        $.each(response, function(event, params) {
          $("body").trigger(event, params);
          $("body").trigger("always");
        });
      }
    }
  });
}
