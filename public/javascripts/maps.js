
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
      
$(function() {
  renderMaps();

  $.polygonInputs();

});