var RegisterNewUserView = RegistrationModalPage.extend({
  template: "registration.new",
  facebookTemplate: "registration.facebook",
  
  events: {
    "click a.show-video": "showVideo",
    "click input.sign_up": "submit",
    "submit form": "submit",
    "click img.facebook": "facebook"
  },
  
  afterRender: function() {
    if (!this.current) {
      this.slideIn(this.el);
      this.current = true;
    }
    
    this.$("input[placeholder]").placeholder();
    
    if (this.data.isFacebook) {
      this.$("input[name=full_name]").val(this.data.full_name);
      if (this.isRealEmail()) { this.$("input[name=email]").val(this.data.email); }
    }
    
    window.test = this;
    
  },
  
  community_name: function() { return this.communityExterior.name; },
  learn_more: function() { return this.communityExterior.links.learn_more },
  created_at: function() { return this.communityExterior.statistics.created_at },
  neighbors: function() { return this.communityExterior.statistics.neighbors },
  feeds: function() { return this.communityExterior.statistics.feeds },
  postlikes: function() { return this.communityExterior.statistics.postlikes },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    this.data.full_name = this.$("input[name=full_name]").val();
    this.data.email = this.$("input[name=email]").val();
    this.data.address = this.$("input[name=street_address]").val();
    
    var validate_api = "/api" + this.communityExterior.links.registration.validate;
    $.getJSON(validate_api, this.data, _.bind(function(response) {
      this.$(".error").hide();
      var valid = true;
      
      if (!_.isEmpty(response.facebook)) {
        window.location.pathname = this.communityExterior.links.facebook_login;
      } else {
        _.each(["full_name", "email", "address"], _.bind(function(field) {
          if (!_.isEmpty(response[field])) {
            var error = this.$(".error." + field);
            var errorText = _.reduce(response[field], function(a, b) { return a + " and " + b; });
            error.text(errorText);
            error.show();
            valid = false;
          }
        }, this));
          
        if (valid) { this.nextPage("profile", this.data); }
      }
    }, this));
  },
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }
    
    facebook_connect_registration({
      success: _.bind(function(data) {
        this.data = data;
        this.data.isFacebook = true;
        this.template = this.facebookTemplate;
        this.render();
      }, this)
    });
  },
  
  isRealEmail: function() {
    if (!this.data || !this.data.email) { return false; }
    return this.data.email.search("proxymail") == -1;
  },
  
  showVideo: function(e) {
    if (e) { e.preventDefault(); }
    var video = this.make("iframe", {
      width: 330,
      height: 215,
      src: "http://www.youtube.com/embed/FXHuFSCasF0",
      frameborder: 0,
      allowfullscreen: true
    });
    this.$("a.show-video").replaceWith(video);
  }
});
