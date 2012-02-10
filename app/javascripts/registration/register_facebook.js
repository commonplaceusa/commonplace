var RegisterFacebookView = CommonPlace.View.extend({
  template: "registration.facebook",
  
  events: {
    "click input.sign_up": "submit"
  },
  
  afterRender: function() {
    // fill out the inputs with stuff we got from facebook
    this.options.slideIn(this.el);
  },
  
  community_name: function() { return this.options.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var data = {
      full_name: this.$("input[name=full_name]").val(),
      email: this.$("input[name=email]").val(),
      address: this.$("input[name=street_address]").val()
    };
    
    $.get("/api/registration/1/validate", data, _.bind(function(response) {
      this.$(".error").hide();
      var valid = true;
      
      _.each(["full_name", "email", "address"], _.bind(function(field) {
        if (!_.isEmpty(response[field])) {
          var error = this.$(".error." + field);
          var errorText = _.reduce(response[field], function(a, b) { return a + " and " + b; });
          error.text(errorText);
          error.show();
          valid = false;
        }
      }, this));
        
      if (valid) { this.options.nextPage("profile", data); }
      
    }, this));
  }
});
