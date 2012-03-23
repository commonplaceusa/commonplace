var LoginView = CommonPlace.View.extend({
    template: "mobile.login",
    events: {
        "click a#register":"register",
        "submit form":"login",
    },

    register: function(e) {
                  e.preventDefault();
                  var RegisterView = new RegisterView({el:$('#main')});
                  RegisterView.render();
              },

    login: function(e) {
                e.preventDefault();
                var email = $("#email").val();
                var password = $("#password").val();
                $.ajax({ 
                    url: "/api/sessions", 
                    contentType: "application/json", 
                    data: JSON.stringify({ email: email, password: password }), 
                    dataType: "json", 
                    success: function(response) { 
                        window.full_name = response.full_name;
                        this.get_recommendations();
                    }

                    error: function() { 
                        console.log("Error!");
                        $("#message").show();
                    } 
                });
        
    },

    get_recommendations: function() {
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
                                      longitude: lng
                                  },
                            success: function(recommendations) {
                                        recommendationsView = new RecommendationsView({el:$('#main'),collection:recommendations});
                                        recommendationsView.render();
                                    }
                        });
                    
                
                         }


});
