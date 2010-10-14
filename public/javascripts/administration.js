

$(function () {

  renderMaps();
  var map = $('[data-map]').first().data('map')

  geocoder = new google.maps.Geocoder();

  google.maps.event.addListener(map,'click', function(event) {

    geocoder.geocode({'latLng': event.latLng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[0]) {
          $.post("/addresses", 
                 {"address[name]": results[0].formatted_address,
                  "address[lat]": results[0].geometry.location.lat(),
                  "address[lng]": results[0].geometry.location.lng()
                 }, function (response) {
                   var address = response.address;
                   if (address.created_at) {
                     renderMarker({position: {lat: address.lat, lng: address.lng}}, map);
                     $("#addresses").prepend("<li>" + address.name + "</li>");
                   }
                   
                   
                 }, "json");
        }
      } else {
        alert("Geocoder failed due to: " + status);
      }

    });
  });

});