var RegisterNewUserView = RegistrationModalPage.extend({
  template: "registration.new",
  facebookTemplate: "registration.facebook",

  events: {
    "click a.show-video": "showVideo",
    "click input.sign_up": "submit",
    "submit form": "submit",
    "click img.facebook": "facebook",
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
    this.$("input[name=street_address]").autocomplete({ source: url , minLength: 1 });

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

    var valid = true;
    var validate_api = "/api" + this.communityExterior.links.registration.validate;
    $.getJSON(validate_api, this.data, _.bind(function(response) {
      this.$(".error").hide();

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

        if(valid) {
          this.$("input[name=full_name]").hide();
          this.$("input[name=email]").hide();
        }

        if(this.$("#suggested_address").is(":hidden") || this.$('#try_again').is(":checked")) {

          var url = '/api/communities/'+this.communityExterior.id+'/address_approximate';
          this.data.term = this.data.address;

          $.get(url, this.data, _.bind(function(response) {
            var radio = this.$("input.address_verify_radio");
            var span = this.$("span.address_verify_radio");
            var addr = this.$("#suggested_address");
            radio.hide();
            span.hide();
            addr.hide();

            console.log(response);

            if(response === null || response[1].length < 1 || response[0] < 0.84) {
              valid = false;

              var error = this.$(".error.address");
              error.text("Please enter a valid address");
              error.show();

            }
            else if(response[0] < 0.94) {
              valid = false;
              var verify = this.$("#verify_text");

              this.data.suggest = response[1];

              verify.empty();
              addr.empty();

              verify.text("Verify this address");
              addr.text(response[1]);
              radio.show();
              span.show();
              addr.show();
            }
            else if(valid) {
              this.data.address = response[1];

              this.nextPage("profile", this.data);
            }
          }, this));
        }
        else {
          if (valid) {
            if(this.$("#suggested_radio").is(':checked')) {
              this.data.address = this.data.suggest;
            }

            this.nextPage("profile", this.data);
          }
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
  },

  showVideo: function(e) {
    if (e) { e.preventDefault(); }
    var video = this.make("iframe", {
      width: 330,
      height: 215,
      src: "http://www.youtube.com/embed/3GIydXPH3Eo?autoplay=1",
      frameborder: 0,
      allowfullscreen: true
    });
    this.$("div.show-video-con").replaceWith(video);
  }
});
