OrganizerApp.MapView = CommonPlace.View.extend({

  template: "organizer_app.map-view",

  afterRender: function() {
    var parentThis = this;
    var now = new Date();
    $('#map-date').val(now.format("mm/dd/yy"));
    $('#map-text').val("dropped flyer");

    var myOptions = {
      center: new google.maps.LatLng(42.6, -71.3733831),
      zoom: 17,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    // map is a global variable
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    console.log("Initializing map view...");
    window.residents = [];
    /*window.residentLatLngs = [];*/
    /*window.residentMarkers = [];*/

    var i = 0;
    this.collection.each(function(model) {
      console.log(model.full_name());
      var id = model.getId();
      if (model.address() && model.getLat()) {
        console.log(model.getLat());
        console.log(model.getLng());
        var ll = new google.maps.LatLng(model.getLat(), model.getLng());
        console.log(ll);
        var marker = new google.maps.Marker({
          map: map,
          position: ll
        });
        google.maps.event.addListener(marker, 'click', function(event) {
          if (!$('#map-date').val() || !$('#map-text').val())
            return;
          var index = parentThis.searchMarkers(marker);
          console.log(window.residents[index]);
          console.log([$.trim($('#map-text').val())]);
          window.residents[index].model.addLog({
            date: $('#map-date').val(),
            text: $('#map-text').val(),
            tags: [$.trim($('#map-text').val())]
          });
        });
        /*window.residentMarkers.push(marker);*/
        /*window.residentLatLngs.push(ll);*/
        window.residents.push({
          id: id,
          marker: marker,
          latLng: ll,
          model: model
        });
      }

      //TODO: tack on community zip code to address
      // geocodes and stores lat and lng into database for residents

      /*if (i < 10 && model.address()) {*/
        /*console.log(model.address());*/
        /*var ms = 2500 + new Date().getTime();*/
        /*while (new Date() < ms) {}*/
        /*this.geocode(model);*/
        /*i++;*/
        /*} else {*/
          /*return;*/
          /*}*/
    }, this);

    /*setTimeout(function() {*/
      /*map.setCenter(window.residentLatLngs[0].latLng);*/
/*}, 1000);*/

    var drawingManager = new google.maps.drawing.DrawingManager({
      drawingMode: google.maps.drawing.OverlayType.MARKER,
      drawingControl: true,
      drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [google.maps.drawing.OverlayType.MARKER, google.maps.drawing.OverlayType.POLYGON, google.maps.drawing.OverlayType.POLYLINE]
      },
      markerOptions: {
        cursor: 'pointer',
        
      },
      polygonOptions: {
        fillColor: '#006600',
        fillOpacity: 1,
        strokeWeight: 3,
        strokeOpacity: 0.1,
        zIndex: 1,
        editable: true
      },
      polylineOptions: {
        zIndex: 2,
        editable: true,
      }
    });
    drawingManager.setMap(map);

    google.maps.event.addListener(drawingManager, 'markercomplete', function(marker) {
      console.log(marker.getPosition());
      var closestResidentIndex = 0;
      var closestResident = window.residentLatLngs[0];
      var closestDistance = 9999;

      // find closest resident to click by linear traversal
      for (var i = 1; i < window.residentLatLngs.length; i++) {
        var nextDistance = Math.sqrt( Math.pow( window.residentLatLngs[i].lat() - closestResident.lat(), 2 ) + Math.pow( window.residentLatLngs[i].lng() - closestResident.lng(), 2 ) );
        if (nextDistance < closestDistance) {
          closestResidentIndex = i;
          closestResident = window.residentLatLngs[i];
        }
      }
      marker.setVisible(false);
      console.log(residentMarkers);
      console.log(closestResidentIndex);
      residentMarkers[closestResidentIndex].setAnimation(google.maps.Animation.BOUNCE);
    });

    google.maps.event.addListener(drawingManager, 'polylinecomplete', function(polyline) {
      var pathMvcArr = polyline.getPath();
      var addresses = [];
      var allPoints = [];
      
      // iterate through each point on the polyline
      pathMvcArr.forEach(function(point, index) {
        console.log("Point " + index);
        console.log(point.toString());
        allPoints.push(point);
      });

      // interpolate between points for all the addresses
      var INTERVAL = 0.0001
      for (var i = 1, l = allPoints.length; i < l; i++) {
        var lat0 = allPoints[i-1].lat();
        var lng0 = allPoints[i-1].lng();
        var lat1 = allPoints[i].lat();
        var lng1 = allPoints[i].lng();
        var deltaLat = lat1 - lat0;
        var deltaLng = lng1 - lng0;
        var latInterval, lngInterval;
        if (deltaLat > deltaLng) {
          latInterval = INTERVAL;
          lngInterval = deltaLng / (deltaLat / INTERVAL);
        } else {
          lngInterval = INTERVAL;
          latInterval = deltaLat / (deltaLng / INTERVAL);
        }
        for (var currentLat = lat0, currentLng = lng0; currentLat < lat1 && currentLng < lng1; currentLat += latInterval, currentLng += lngInterval) {
          var point = new google.maps.LatLng(currentLat, currentLng);
          allPoints.push(point);
        }
      }

      for (var i = 0; i < allPoints.length; i++) {
        // reverse geocode point to hopefully get an address
        console.log(allPoints.length);
        console.log(allPoints[i]);
        var a = parentThis.reverseGeocode(map, allPoints[i]);
        while (a == false) {
          console.log(a);
          var ms = 3000 + new Date().getTime();
          while (new Date() < ms) {}
          a = parentThis.reverseGeocode(map, allPoints[i]);
        }
        addresses.push(a);
      }
      console.log("addresses: ");
      console.log(addresses);
    });

  },

  searchMarkers: function(marker) {
    for (var i = 0; i < window.residents.length; i++) {
      if (window.residents[i].marker == marker) {
        return i;
      }
    }
    return -1;
  },

  /*handleNoGeolocation: function(errorFlag) {*/
    /*if (errorFlag) {*/
      /*var content = "Error: The Geolocation service failed.";*/
      /*} else {*/
        /*var content = "Error: Your browser doesn't support geolocation.";*/
        /*}*/

        /*var options = {*/
          /*map: map,*/
          /*position: new google.maps.LatLng(60, 105),*/
          /*content: content*/
          /*};*/

          /*var infowindow = new google.maps.InfoWindow(options);*/
          /*map.setCenter(options.position);*/
          /*},*/

  geocode: function(model) {
    var geocoder = new google.maps.Geocoder();
    var address = model.address() + " 01824";
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        var latLng = results[0].geometry.location;
        var marker = new google.maps.Marker({
          map: map,
          position: latLng
        });
        window.residentLatLngs.push({ "residentId": model.getId(), "latLng": latLng });
        model.save({ latitude: latLng.lat(), longitude: latLng.lng() }, {success: console.log(model.getId() + " latLng update success")});
      } else {
        console.log("Geocode was not successful for the following reason: " + status);
      }
    });
  },

  reverseGeocode: function(map, point) {
    console.log(point);
    var geocoder = new google.maps.Geocoder();
    var success;
    geocoder.geocode({'latLng': point}, function(results, status) {

      // if geocode is successful
      if (status == google.maps.GeocoderStatus.OK) {
        var addr = results[0];
        var marker = new google.maps.Marker({
          map: map,
          position: addr.geometry.location
        });
        /*console.log(addr);*/
        /*console.log(addr.types[0]);*/
        /*console.log(addr.formatted_address);*/
        var addrString = "";
        var isBuilding = false;

        for (var j = 0; j < addr.address_components.length; j++) {
          var component = addr.address_components[j];
          switch (component.types[0]) {
            case "street_number":
              addrString += component.short_name + " ";
              isBuilding = true;
              break;
            case "route":
              addrString += component.short_name; // + ", ";
              break;
            /*case "locality":*/
              /*addrString += component.short_name + ", ";*/
              /*break;*/
            /*case "administrative_area_level_1":*/
              /*addrString += component.short_name + " ";*/
              /*break;*/
            /*case "postal_code":*/
              /*addrString += component.short_name;*/
              /*break;*/
            default:
          }
        }
        console.log(addrString);
        if (isBuilding) {
          success = addrString;
        } else {
          console.log("No street number received, thus probably not a building");
          success = false;
        }

        // if geocode fails
      } else {
        console.log("Error in geocoding. Reason: " + status);
        success = false;
      }
    });
    return success;
  }

});

