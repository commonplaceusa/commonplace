
function renderMaps() {
  if (window.google) {
    $('div[data-map]').each(function() {
      var $this = $(this);
      var args = $.parseJSON($this.attr('data-map'));
      if (args && args.center) {
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode({address:args.center}, function (results) {
          var map = new google.maps.Map($this.get(0), {
            zoom: 15,
            center: results[0].geometry.location,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            navigationControl: true,
            mapTypeControl: false,
            scaleControl: true
          });
          
          $this.data('map', map);
          $.each(args.markers, function() {renderMarker(this,map,geocoder)});
          $.each(args.polygons, function() {renderPolygon(this,map)});
          $.each(args.directions, function() {renderDirections(this,map)});
        });
      }
    });
  }
}

function renderMarker(args,map,geocoder) {
  geocoder.geocode({address:args.position}, function(results) {
    new google.maps.Marker({
      position: results[0].geometry.location,
      map: map
    });
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
    origin: args.origin,
    destination: args.destination,
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