/*
 * jello-pudding
 *
 */
 /*

 * Update
 * shift between two different data sets
 * map color options
 * clickableness
 * nice controlls
 * centering all nice and nice

  */


(function($){
  $.fn.jellopudding = function(source_selector) {
    var $source = $(source_selector);
    var $map = $(this);
    var map_elem = $map.get(0);
    var map_selector = $map.selector
    
    if (typeof map_elem == 'undefined') {
      alert("invalid map selector: " + map_selector);
      return null;
    }

    var markers = $source.map(function(){
      if (!$(this).attr('data-marker')) {
          return null;
      }      
      var o = jQuery.parseJSON( $(this).attr('data-marker') );

      return new google.maps.Marker({
        title: o.info_html,
        position: new google.maps.LatLng(o.lat,o.lng)
      });
    });

    if ($map.data(source_selector)) {

      $map.data(source_selector).clearMarkers();
      $map.data(source_selector).addMarkers(markers,0);
      $map.data(source_selector).refresh();

    } else {
      if (!$map.data("map")) {
        $map.data("map", new google.maps.Map(map_elem, {
          zoom: 5,
	  center: new google.maps.LatLng(41,-71),
	  mapTypeId: google.maps.MapTypeId.ROADMAP
        }));
      }
      $map.data(source_selector, new MarkerManager($map.data("map")));
      google.maps.event.addListener($map.data(source_selector), 'loaded', function() {
	$map.data(source_selector).addMarkers(markers,0);
	$map.data(source_selector).refresh();
      });
      
    }
    
    return this;
  };
  

})(jQuery);