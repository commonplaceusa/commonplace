var LandingView = CommonPlace.View.extend({
    template: "mobile.landing",
    id: "main",

    events: {
        "click #login":function(e) {
            e.preventDefault();
            var loginView = new LoginView();
            loginView.render();
          $("#main").replaceWith(loginView.el);
        },
        "click #register":function(e) {
            e.preventDefault();
            var registerView = new RegisterView();
            registerView.render();
          $("#main").replaceWith(registerView.el);
        }
    }
});
