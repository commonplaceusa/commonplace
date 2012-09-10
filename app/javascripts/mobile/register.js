var RegisterView = CommonPlace.View.extend({
    template: "mobile.register",
    id: "main",
    events: {"submit form":"register"},

    register: function(e) {
      e.preventDefault();
        var full_name = $("#full_name").val();
        var email = $("#email").val();
        var address = $("#address1").val() + " " + $("#address2").val();
        var password = $("#password").val();
        var password2 = $("#password2").val();
        var errors = false;
        if (full_name == "" || email == "" || address == " " || password == "") {
            errors = true;
            $("#errors").append("Error: you must fill out all fields. ");
        }

        if (password != password2) {
            errors = true;
            $("#errors").append("Error: passwords must match. ");
        }

        if (errors) {
            $("#errors").append("Please try again! ");
        } else {
            window.full_name = full_name;
            $("#errors").empty();
            var community_id = "1";
            // API call to register user
            $.ajax({
                type: "POST",
                  contentType: "application/json",
                  dataType: "json",
                  url: "api/registration/" + community_id + "/new",
                  data: JSON.stringify({ full_name: full_name, email: email, address: address, password: password }),
                  success: function(response) {
                        $.getJSON("/api/account", function(response) {
                            window.account = response;
                            window.full_name = response.full_name;
                            get_recommendations();
                        },
                        function(response) {
                            $("#errors").append("There was an error finding nearby places!");
                        });
                    },

                  error: function() {
                      $("#errors").append("There was an error in registration. Please try again!");
                  }
            });

        }
    }
});



                      // log the user in (I guess this is unnecessary)
                      /*
                      $.ajax({
                            url: "/api/sessions",
                            contentType: "application/json",
                            data: JSON.stringify({ email: email, password: password }),
                            dataType: "json",
                            success: function(response) {
                                window.full_name = response.full_name;
                                var LoginView = new LoginView();
                                LoginView.get_recommendations();
                            },
                            error: function() {
                                   }
                      });


                      // this is bad; I'm repeating code
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
                                       recommendationsView = new RecommendationsView({el:$("#main"),collection:recommendations});
                                       recommendationsView.render();
                                   }
                      });

                  */
