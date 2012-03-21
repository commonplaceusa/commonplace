var RecommendationView = CommonPlace.View.extend({
    template: "mobile.recommendations",

    recommendations: function() {
        return this.collection.toJSON();
    },

    distance: function() {
                  geo_position_js.getCurrentPosition(function(loc) {
                      var lat1 = loc.coords.latitude;
                      var lng1 = loc.coords.longitude;
                      var lat2 = this.latitude;
                      var lng2 = this.longtitude;
                      var p1 = new LatLon(lat1,lng1);
                      var p2 = new LatLon(lat2,lng2);
                      var dist_km = p1.distanceTo(p2);
                      if (dist_km < 1) {
                          return dist_km*1000 + " m";
                      } else {
                          return dist_km + " km";
                      }
                  });
    },

    events: {
                "click .item":function(e) {
                    var id = $(e.currentTarget).data('id');
                    var rec = this.collection.get(id);
                    var ImInView = new ImInView({el:$('#main'), model:rec});
                    ImInView.render();
                }
            }
});

