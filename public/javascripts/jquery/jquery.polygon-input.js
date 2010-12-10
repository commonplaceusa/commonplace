(function($) {
  $.polygonInputs = function() {
    $("textarea.polygon").each(function() {
      var $input = $(this),
      $canvas = $("<div class='polygon-canvas'></div>"),
      $canvasLocation = $("<input type='text' placeholder='Address' class='polygon-location'>"),
      $goButton = $("<button class='polygon-go'>Go</button>"),
      $clearButton = $("<button class='polygon-clear'>Clear</button>"),
      geocoder = new google.maps.Geocoder();
      
      $input.before($canvasLocation);
      $input.before($goButton);
      $input.before($clearButton);
      $input.before($canvas);                    
      var map = new google.maps.Map($canvas.get(0), {
        zoom: 15,
        center: new google.maps.LatLng(0,0),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        nagivationControl: true,
        mapTypeControl: false,
        scaleControl: true
      }),
      polygon = new google.maps.Polygon({
        clickable: false,
        paths: [[]],
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        map: map
      });
      function setInput() {
        $input.val("[" + 
                   $.map(polygon.getPath().getArray(), 
                       function(e) { 
                         return "[" + e.lat() + ", " + e.lng() + "]"
                       }).join(", ") 
                   + "]");
      }
      setInput();
      google.maps.event.addListener(map, 'click', function(event) {
        polygon.getPath().push(event.latLng);
        setInput();
      });
      
      $goButton.click(function(e) {
        e.preventDefault();
        geocoder.geocode({address: $canvasLocation.val()}, function(r,s) {
          map.panTo(r[0].geometry.location);
        });
      });
      
      $clearButton.click(function(e) {
        e.preventDefault();
        polygon.setPath([]);
        setInput();
      });
      
    })
      }
})(jQuery);
