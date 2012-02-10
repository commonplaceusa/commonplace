var RegisterNewUserView = CommonPlace.View.extend({
  template: "registration.new",
  
  events: {
    "click input.sign_up": "submit",
    "submit form": "submit"
  },
  
  initialize: function(options) {
    this.communityExterior = options.communityExterior;
    this.statistics = this.communityExterior.statistics;
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
  },
  
  community_name: function() { return this.communityExterior.name; },
  
  learn_more: function() { return this.communityExterior.links.learn_more },
  
  facebook: function() { return this.communityExterior.links.facebook },
  
  created_at: function() { return this.statistics.created_at },
  neighbors: function() { return this.statistics.neighbors },
  feeds: function() { return this.statistics.feeds },
  postlikes: function() { return this.statistics.postlikes },
  
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
