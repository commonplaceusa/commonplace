var LoginView = CommonPlace.View.extend({
    template: "mobile.login",
    events: {"submit form":"login"},

    login: function(e) {
                // prevent default
               // authenticate
        
                var lat = null;
                var lng = null;
                if (geo_position_js.init()) {
                    geo_position_js.getCurrentPosition(function(loc) {
                        lat = loc.coords.latitude;
                        lng = loc.coords.longitude;
                    });
                }

                new Recommendations([]).fetch({
                    data: {
                              latitude: lat,
                              longittude: lng
                          },
                    success: function(recommendations) {
                                recommendationsView = new RecommendationsView({el:$('#main'),collection:recommendations});
                                recommendationsView.render();
                             }
                });
    }
});
