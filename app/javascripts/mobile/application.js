
MobileView = CommonPlace.View.extend({
  
  template: "mobile.landing",

  hello: function() { return "world"; }

});


$(function() {

    $.ajax({
        url: "/api/account",
        contentType: "application/json",
        data: {},
        dataType: "json",
        success: function(response) {
            window.account = response;
            window.full_name = response.name;
            console.log("success");
            get_recommendations();
        },
        error: function() {
            var view = new LandingView({ el: $("#main") });
            view.render();
        }
    });

});
