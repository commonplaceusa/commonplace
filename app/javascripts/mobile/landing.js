var LandingView = CommonPlace.View.extend({
    template: "mobile.landing",

    events: {
        "click #login":function(e) {
            e.preventDefault();
            var LoginView = new LoginView({el:$('#main')});
            LoginView.render();
        },
        "click #register":function(e) {
            e.preventDefault();
            var RegisterView = new RegisterView({el:$('#main')});
            RegisterView.render();
        }
    }
});
