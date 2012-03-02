var LoginView = CommonPlace.View.extend({
    template: "mobile.login",
    events: {"submit form":"login"}

    login: function(e) {
                // prevent default
               // authenticate
               // get recommendations collection
        recommendationsView = new RecommendationsView({el:$('#main'),collection:recommendations});
        recommendationsView.render();
    }
});
