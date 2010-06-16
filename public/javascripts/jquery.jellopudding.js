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
  $.fn.jellopudding = function(info) {
    var map = this;

    var map_elem = map.get(0);

    if (typeof map_elem == 'undefined') {
      alert("invalid map selector: " + map.selector);
      return null;
    }

    if (info) map.data('info',info);

    if ( !map.data('info') ) {
      alert('no source of data');
      return null;
    }

    var markers = jQuery.map( $(map.data('info')).children(), function(elem){
	    var o = jQuery.parseJSON( $(elem).attr('data-marker') );
	    return new google.maps.Marker({
        title: o.info_html,
      	position: new google.maps.LatLng(o.lat, o.lng)
	    });
    });

    if (map.data('mgr')) {

      map.data('mgr').clearMarkers();
      map.data('mgr').addMarkers(markers,0);
      map.data('mgr').refresh();

    } else {
      map.data('mgr', new MarkerManager(new google.maps.Map(map_elem, {
	      zoom: 5,
	      center: new google.maps.LatLng(41,-71),
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    })));

      google.maps.event.addListener(map.data('mgr'), 'loaded', function() {
	      map.data('mgr').addMarkers(markers,0);
	      map.data('mgr').refresh();
      });

    }

    return this;
  };


})(jQuery);