var LandingView = CommonPlace.View.extend({
    template: "mobile.landing",

    events: {
        "click #login":function(e) {
            e.preventDefault();
            var loginView = new LoginView({el:$('#main')});
            loginView.render();
        },
        "click #register":function(e) {
            e.preventDefault();
            var registerView = new RegisterView({el:$('#main')});
            registerView.render();
        }
    }
});
