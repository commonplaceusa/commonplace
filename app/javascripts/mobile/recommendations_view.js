var RecommendationsView = CommonPlace.View.extend({
    template: "mobile.recommendations",

    user: function() {
        return window.full_name;
    },

  aroundRender: function(render) {
    var self = this;
    geo_position_js.getCurrentPosition(function(loc) {
      window.loc = loc;
      console.log(loc);
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
        console.log(window.loc);
      var lat1 = window.loc.coords.latitude;
      var lng1 = window.loc.coords.longitude;
      var lat2 = recommendation.latitude;
      var lng2 = recommendation.longitude;
      console.log("lat1="+lat1+",lat2="+lat2+"lng1="+lng1+"lng2="+lng2);
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
                "click .recommendation":function(e) {
                    e.preventDefault();
                    console.log($(e.currentTarget).data('id'));
                    var id = $(e.currentTarget).data('id');
                    var rec = this.collection.get(id);
                    console.log("rec:"+rec);
                    var imInView = new ImInView({el:$('#main'), model:rec});
                    imInView.render();
                }
            }
});

