OrganizerApp.MapView = CommonPlace.View.extend({

  template: "organizer_app.map-view",

  afterRender: function() {
    console.log("Initializing map view...");
    var myOptions = {
      center: new google.maps.LatLng(-34.397, 150.644),
      zoom: 17,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"),
    myOptions);
    var geocoder = new google.maps.Geocoder();

    // Try HTML5 geolocation
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = new google.maps.LatLng(position.coords.latitude,
        position.coords.longitude);

        var infowindow = new google.maps.InfoWindow({
          map: map,
          position: pos,
          content: 'You are here!'
        });

        map.setCenter(pos);
      }, function() {
        this.handleNoGeolocation(true);
      });
    } else {
      // Browser doesn't support Geolocation
      this.handleNoGeolocation(false);
    }

    var drawingManager = new google.maps.drawing.DrawingManager({
      drawingMode: google.maps.drawing.OverlayType.MARKER,
      drawingControl: true,
      drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [google.maps.drawing.OverlayType.MARKER, google.maps.drawing.OverlayType.CIRCLE, google.maps.drawing.OverlayType.POLYLINE]
      },
      markerOptions: {
        icon: new google.maps.MarkerImage('http://hpwebsolutions.com/assets/images/IntenetAndEmailMarketing/icon-48x48-flag_green.png')
      },
      circleOptions: {
        fillColor: '#ffff00',
        fillOpacity: 1,
        strokeWeight: 5,
        clickable: false,
        zIndex: 1,
        editable: true
      },
      polylineOptions: {
        zIndex: 2,
        editable: true,
      }
    });
    drawingManager.setMap(map);

    google.maps.event.addListener(drawingManager, 'polylinecomplete', function(polyline) {
      var pathMvcArr = polyline.getPath();
      var addresses = [];
      pathMvcArr.forEach(function(point, index) {
        console.log("Point " + index);
        console.log(point.toString());
        geocoder.geocode({'latLng': point}, function(results, status) {
          var addr = results[0];
          if (status == google.maps.GeocoderStatus.OK) {
            var marker = new google.maps.Marker({
              map: map,
              position: addr.geometry.location
            });
            console.log(addr);
            console.log(addr.types[0]);
            console.log(addr.formatted_address);
            for (var i = 0; i < addr.address_components.length; i++) {
              switch (addr.address_components[i].types[0]) {
                case "street_address":
                  alert("sa");
                  break;
                default:
                  alert("d");
              }
            }
          } else {
            alert("Error in geocoding. Reason: " + status);
          }
        });
      });
    });

  },

  handleNoGeolocation: function(errorFlag) {
    if (errorFlag) {
      var content = "Error: The Geolocation service failed.";
    } else {
      var content = "Error: Your browser doesn't support geolocation.";
    }

    var options = {
      map: map,
      position: new google.maps.LatLng(60, 105),
      content: content
    };

    var infowindow = new google.maps.InfoWindow(options);
    map.setCenter(options.position);
  }
/*events: {*/
/*"click li": "onClickFile",*/
/*"click #filter-button": "filter",*/
/*"click .tag-filter": "cycleFilter",*/
/*"click #map-button": "showMapView"*/
/*},*/

});
