OrganizerApp.MapView = CommonPlace.View.extend({

  template: "organizer_app.map-view",

  afterRender: function() {
    var myOptions = {
      center: new google.maps.LatLng(-34.397, 150.644),
      zoom: 17,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    // map is a global variable
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    console.log("Initializing map view...");
    window.residentLatLngs = [];

    var i = 0;
    this.collection.each(function(model) {
      console.log(model.full_name());
      
      //TODO: tack on community zip code to address
      // geocodes and stores lat and lng into database for residents
      if (i < 10 && model.address()) {
        console.log(model.address());
        var ms = 2500 + new Date().getTime();
        while (new Date() < ms) {}
        this.geocode(model);
        i++;
      }
    }, this);
    setTimeout(function() {
      map.setCenter(window.residentLatLngs[0].latLng);
    }, 1000);
    /*console.log(this.collection);*/

    /*// Try HTML5 geolocation*/
    /*if(navigator.geolocation) {*/
      /*navigator.geolocation.getCurrentPosition(function(position) {*/
        /*var pos = new google.maps.LatLng(position.coords.latitude,*/
/*position.coords.longitude);*/

          /*var infowindow = new google.maps.InfoWindow({*/
            /*map: map,*/
            /*position: pos,*/
            /*content: 'You are here!'*/
/*});*/

            /*map.setCenter(pos);*/
            /*}, function() {*/
              /*this.handleNoGeolocation(true);*/
/*});*/
              /*} else {*/
                /*// Browser doesn't support Geolocation*/
                /*this.handleNoGeolocation(false);*/
                /*}*/

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

    var parentThis = this;
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
