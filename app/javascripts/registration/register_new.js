var RegisterNewUserView = CommonPlace.View.extend({
  template: "registration.new",
  
  events: {
    "click input.sign_up": "submit",
    "submit form": "submit",
    "click img.facebook": "facebook"
  },
  
  initialize: function(options) {
    this.communityExterior = options.communityExterior;
    this.statistics = this.communityExterior.statistics;
    if (options.data) {
      this.data = options.data;
      if (this.data.isFacebook) { this.template = "registration.facebook"; }
    } else {
      this.data = { isFacebook: false };
    }
  },
  
  afterRender: function() {
    if (this.data.isFacebook) {
      this.$("input[name=full_name]").val(this.data.full_name);
      this.$("input[name=email]").val(this.data.email);
    }
    this.options.slideIn(this.el);
  },
  
  community_name: function() { return this.communityExterior.name; },
  learn_more: function() { return this.communityExterior.links.learn_more },
  created_at: function() { return this.statistics.created_at },
  neighbors: function() { return this.statistics.neighbors },
  feeds: function() { return this.statistics.feeds },
  postlikes: function() { return this.statistics.postlikes },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    this.data.full_name = this.$("input[name=full_name]").val();
    this.data.email = this.$("input[name=email]").val();
    this.data.address = this.$("input[name=street_address]").val();
    
    var validate_api = "/api" + this.communityExterior.links.registration.validate;
    $.getJSON(validate_api, this.data, _.bind(function(response) {
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
        
      if (valid) { this.options.nextPage("profile", this.data); }
      
    }, this));
  },
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }
    
    facebook_connect_registration({
      success: _.bind(function(data) {
        this.data = data;
        this.data.isFacebook = true;
        this.template = "registration.facebook";
        this.render();
      }, this)
    });
  }
});
