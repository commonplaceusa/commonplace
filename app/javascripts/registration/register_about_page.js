var AboutPageRegisterNewUserView = RegistrationModalPage.extend({
  template: "registration.new_about_page",
  facebookTemplate: "registration.facebook",

  events: {
    "click button.next-button": "submit",
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
    var domains = ["hotmail.com", "gmail.com", "aol.com", "yahoo.com"];

    this.$("input#email").blur(function() {
      $("input#email").mailcheck(domains, {
      suggested: function(element, suggestion) {
        $(".error.email").html("Did you mean " + suggestion.full + "?");
        $(".error.email").show();
        $(".error.email").click(function(e) {
          $(element).val(suggestion.full);
        });
      },
      empty: function(element) {
        $(".error.email").hide();
      }
    });
    });

    var url = '/api/communities/'+this.communityExterior.id+'/address_completions'
    this.$("input[name=street_address]").autocomplete({ source: url , minLength: 2 });

  },

  community_name: function() { return this.communityExterior.name; },
  learn_more: function() { return this.communityExterior.links.learn_more; },
  created_at: function() { return this.communityExterior.statistics.created_at; },
  neighbors: function() { return this.communityExterior.statistics.neighbors; },
  feeds: function() { return this.communityExterior.statistics.feeds; },
  postlikes: function() { return this.communityExterior.statistics.postlikes; },

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

        if (valid) {
          new_url = "/" + this.communityExterior.slug + "/register/profile?name=" + this.data.full_name +
            "&email=" + this.data.email +
            "&address=" + this.data.address;
          window.location.href = new_url;
        }
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
  }
});

