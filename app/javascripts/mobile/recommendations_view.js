var RecommendationView = CommonPlace.View.extend({
    template: "mobile.recommendations",

    user: function() {
        return window.full_name;
    },

  aroundRender: function(render) {
    var self = this;
    geo_position_js.getCurrentPosition(function(loc) {
      self.location = loc;
      render();
    });

  },

    recommendations: function() {
      var self = this;
      return _.map(this.collection.toJSON(), function(rec) {
        rec.distance = self.distanceTo(rec);
        return rec;
      });
    },

    distanceTo: function(recommendation) {
      var lat1 = self.location.coords.latitude;
      var lng1 = self.location.coords.longitude;
      var lat2 = recommendation.latitude;
      var lng2 = recommendation.longtitude;
      var p1 = new LatLon(lat1,lng1);
      var p2 = new LatLon(lat2,lng2);
      var dist_km = p1.distanceTo(p2);
      if (dist_km < 1) {
        return dist_km*1000 + " m";
      } else {
        return dist_km + " km";
      }
    },

    events: {
                "click .item":function(e) {
                    e.preventDefault();
                    var id = $(e.currentTarget).data('id');
                    var rec = this.collection.get(id);
                    var ImInView = new ImInView({el:$('#main'), model:rec});
                    ImInView.render();
                }
            }
});

