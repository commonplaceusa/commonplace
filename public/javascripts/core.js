Sammy.CPLocationProxy = function(app) {
  this.app = app;
  this._last_location = "";
};

Sammy.CPLocationProxy.prototype = {
  bind: function () {},
  unbind: function() {},
  getLocation: function() {
    var matches = window.location.toString().match(/^[^#]*#(.+)$/);
    return matches ? matches[1] : '';
  },
  setLocation: function(new_location) {
    this._last_location = this.getLocation();
    if (window._gaq) {
      _gaq.push(['_trackPageview', location.pathname + location.hash]);
    }
    return (window.location = "#" + new_location);
  }
};

$(function() {
  $('input[placeholder], textarea[placeholder]').placeholder();
  $.polygonInputs();

  $('.edit_new input:text, .edit_new textarea').keydown(function(e) {
    var $input = $(e.currentTarget);
    setTimeout(function(){$('.edit_new .info_box .' + $input.attr('id')).html($input.val());}, 10);
  });


  $('.item .body').truncate({max_length: 160});
  jQuery.extend({
    put: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'PUT');
    },
    del: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'DELETE');
    }
  });
  
  $('.tooltip').live('mouseover',function() {
    $('#tooltip').html($(this).attr('data-title'));
  }).live('mouseout', function() {
    $('#tooltip').html($('#tooltip').attr('title'));
  });

  $('a[data-remote]').live('click', function(e) {
    $.sammy("body").setLocation($(this).attr('href'));
    $.sammy("body").runRoute($(this).attr('data-method') || "get", $(this).attr('href'), {}, this);
    e.preventDefault();
  });

  $('div[data-href]').live('click', function(e) {
    $.sammy("body").setLocation($(this).attr('data-href'));
    $.sammy("body").runRoute($(this).attr('data-method') || "get", $(this).attr('data-href'), {}, this);
  });

  $('div[data-href] a').live('click', function(e) {
    if ($(this).attr('data-remote')) {
      $.sammy("body").setLocation($(this).attr('href'));
      $.sammy("body").runRoute($(this).attr('data-method') || "get", $(this).attr('href'), {}, this);
      e.preventDefault();
    }
    e.stopPropagation();
  });

  $('textarea').autoResize({animateDuration: 0, extraSpace: 20, animate: false});

  $('#org_url').textTruncate(140);

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
  $(window).trigger('resize.modal');
  
  renderMaps();
});

function renderMaps() {
  if (window.google) {
    $('div[data-map]').each(function() {
      var args = $.parseJSON($(this).attr('data-map'));
      if (args && args.center) {
        var map = new google.maps.Map(this, {
          zoom: 15,
          center: jsonToLatLng(args.center),
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          navigationControl: true,
          mapTypeControl: false,
          scaleControl: true
        });
        $(this).data('map', map);
        $.each(args.markers, function() {renderMarker(this,map)});
        $.each(args.polygons, function() {renderPolygon(this,map)});
        $.each(args.directions, function() {renderDirections(this,map)});
      }
    });
  }
}

function renderMarker(args,map) {
  new google.maps.Marker({
    position: jsonToLatLng(args.position),
    map: map
  });
}

function jsonToLatLng(args) {
  return new google.maps.LatLng(args.lat,args.lng);
}

function renderPolygon(args,map) {
  var path = $.map(args.vertices, jsonToLatLng),
  neighborhood = new google.maps.Polygon({
    paths: path,
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
        fillOpacity: 0.35
  });
  neighborhood.setMap(map);
}
function renderDirections(args,map) {
  if (!args.origin) return;
  var directionsService = new google.maps.DirectionsService(),
  directionsDisplay = new google.maps.DirectionsRenderer({ 
    suppressMarkers: true
  }),
  directionsRequest = {
    origin: jsonToLatLng(args.origin),
    destination: jsonToLatLng(args.destination),
    travelMode: google.maps.DirectionsTravelMode.WALKING
  };
  directionsDisplay.setMap(map);
  directionsService.route(directionsRequest, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
}
      
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

function setInfoBoxPosition() {
  if ($('#information').get(0) && $('#zones').get(0)) {
    if ($(window).scrollTop() + 10 > $('#zones').offset().top + $('#zones').height()){
      $('#information').css({'position':'fixed','top': 10, 'margin-left': $("#syndicate").width() + 14});
    } else {
      $('#information').css({'position': 'static', 'margin-left': 0});
    }
  }
}

function showTooltips() {
  $('#tooltip').html(function() {
    return ($('#zones .selected_nav').attr('data-title') || $(this).attr('title'));
  });
};

function merge(html, context) {
  if (html) {
    $.each(html, function(selector, content) {
      if (content) {
        $(selector).replaceWith(window.innerShiv(content, false));
      }
    });
  }
  $('.item .body').truncate({max_length: 160});
  $('.disabled_link, a[href=disabled]').attr('title', "Coming soon!").tipsy({gravity: 'n'});
  showTooltips();
  $('#tooltip').html($('#tooltip').attr('title'));
  renderMaps();
//  setInfoBoxPosition();
  $('input.date').datepicker({
    prevText: '&laquo;',
    nextText: '&raquo;',
    showOtherMonths: true,
    defaultDate: null
  });
  
  $('#modules').sortable();
  $('#modules').disableSelection();
  $(window).trigger('resize.modal');
  $("#avatar_to_crop").load(function() {
    $(window).trigger('resize.modal');
    $('#avatar_to_crop').Jcrop({
      aspectRatio: 1,
      onChange: function(args) {
        $("#avatar_x").val(args.x);
        $("#avatar_y").val(args.y);
            $("#avatar_w").val(args.w);
        $("#avatar_h").val(args.h);
      }
    });
  });
}

function currentIndex(path) {
  return path.replace(/\/[^\/]*$/,"");
}

function accordionItem($item) {
  var $replies = $item.children(".replies"),
      $body = $item.find(".body");
  $("#syndicate .replies").not($replies.get(0)).slideUp();
  $("#syndicate .body").not($body.get(0)).truncate('truncate');
  $replies.slideDown();
  $body.truncate('untruncate');
}
function initInlineForm() {
  $(".inline-form").bind("edit.inline-form", function() {
    $("[data-field]", $(this)).attr('contenteditable', true);
    $(this).addClass("editable");
  });
  $(".inline-form").bind("save.inline-form", function() {
    var data = {};
    $("[data-field]", $(this)).each(function() {
      data[$(this).attr('data-field')] = $(this).html();
    });
    $.ajax({
      type: $(this).attr('data-form-method'),
      url: $(this).attr('data-form-url'),
      data: data,
      success: function(response) {
        $('#information').replaceWith(response.content);
        initInlineForm();
        renderMaps();
      },
      dataType: "json"
    });
  });
  $(".inline-form").bind("revert.inline-form", function() {
    $("[data-field]", $(this)).removeAttr('contenteditable');
    $(this).removeClass("editable");
  });

  $('.inline-form .inline-edit').click(function(e) {
    $(this).trigger('edit.inline-form');
    e.stopPropagation();
  });

  $('.inline-form .inline-save').click(function(e) {
    $(this).trigger('save.inline-form');
    e.stopPropagation();
  });

  $('.inline-form .inline-cancel').click(function(e) {
    $(this).trigger('revert.inline-form');
    e.stopPropagation();
  });
}