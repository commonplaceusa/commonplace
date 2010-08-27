
$(function() {
  $("input[name='_method']").each(function() { 
    var method = $(this).val(); 
    $(this).closest('form').attr('method', method); 
  }); 

  $('a[data-remote]').live('click', function(e) {
    app.location_proxy.setLocation("#" + $(this).attr('href'));
    e.preventDefault()
  });

  $('textarea').autoResize({animateDuration: 50, extraSpace: 5});

  $('#toggle_map').toggle( function(){
    $('#map').css({
      width: "100%",
      height: "250px",
      "margin-bottom": "10px"
    });
    $("#toggle_map").html("COLLAPSE MAP");
  }, function() {
    $('#map').css({
      width: "200px",
      height: "150px",
      "margin-bottom": "0"
    });
    $("#toggle_map").html("EXPAND MAP / GET DIRECTIONS");
  });

  $('#org_url').textTruncate(140);

});


function setModal() {
  $.getJSON(this.path.slice(1), function(response) {
    $(response.form).modal({
      overlayClose: true,
      onClose: function() { 
        $.modal.close(); 
        history.back()
      }
    });
  });
}

function renderMap(args) {
  var directionsService = new google.maps.DirectionsService(),
      directionsDisplay = new google.maps.DirectionsRenderer({ 
        suppressMarkers: true
      }),
      from = new google.maps.LatLng(args.directions.from.lat, args.directions.from.lng),
      to = new google.maps.LatLng(args.directions.to.lat, args.directions.to.lng),
      myOptions = {
        zoom: 15,
        center: from,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        navigationControl: true,
        mapTypeControl: false,
        scaleControl: true
      },
      map = new google.maps.Map(document.getElementById("map"), myOptions),
      directionsRequest = {
        origin: from,
        destination: to,
        travelMode: google.maps.DirectionsTravelMode.WALKING
      };

  
  directionsDisplay.setMap(map);    
  var fromMarker = new google.maps.Marker({
    position: from, 
    map: map
  });
  var toMarker = new google.maps.Marker({
    position: to,
    map: map
  });

  directionsService.route(directionsRequest, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
}


