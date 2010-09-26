
$(function() {
  jQuery.extend({
    put: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'DELETE');
    }
  });

  $('a[data-remote]').live('click', function(e) {
    app.location_proxy.setLocation("#" + $(this).attr('href'));
    e.preventDefault()
  });

  $('textarea').autoResize({animateDuration: 50, extraSpace: 5});

  $('#org_url').textTruncate(140);

});

function setModal() {
  $.getJSON(this.path.slice(1), function(response) {
    $(response.form).modal({
      overlayClose: true,
      onClose: function() { 
        $.modal.close(); 
      }
    });
  });
}


function renderMaps() {
  $('div[data-map]').each(function() {
    var args = $.parseJSON($(this).attr('data-map')),
        defaultOptions = {
          zoom: 15,
          center: jsonToLatLng(args.center),
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          navigationControl: true,
          mapTypeControl: false,
          scaleControl: true
        },
        map = new google.maps.Map(this, defaultOptions);
    $(this).data('map', map);
    $.each(args.markers, function() {renderMarker(this,map)});
    $.each(args.polygons, function() {renderPolygon(this,map)});
    $.each(args.directions, function() {renderDirections(this,map)});
  });
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