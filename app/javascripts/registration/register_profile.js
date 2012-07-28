var RegisterProfileView = RegistrationModalPage.extend({
  template: "registration.profile",
  facebookTemplate: "registration.facebook_profile",

  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click img.facebook": "facebook"
  },

  afterRender: function() {
    this.hasAvatarFile = false;
    this.initReferralQuestions();

    if (!this.data.isFacebook) {
      this.initAvatarUploader(this.$(".avatar_file_browse"));
    }

    if (!this.current) {
      this.slideIn(this.el);
      this.current = true;
    }

    //this.$("textarea").autoResize();

    this.$("select.list").chosen().change({}, function() {
      var clickable = $(this).parent("li").children("div").children("ul");
      clickable.click();
    });
  },

  community_name: function() { return this.communityExterior.name; },

  user_name: function() {
    return (this.data.full_name) ? this.data.full_name.split(" ")[0] : "";
  },

  avatar_url: function() {
    return (this.data.avatar_url) ? this.data.avatar_url : "";
  },

  submit: function(e) {
    if (e) { e.preventDefault(); }
    this.$(".error").hide();
    this.data.password = this.$("input[name=password]").val();
    this.data.about = this.$("textarea[name=about]").val();
    this.data.organizations = this.$("textarea[name=organizations]").val();

    _.each(["interests", "skills", "goods"], _.bind(function(listname) {
      var list = this.$("select[name=" + listname + "]").val();
      if (!_.isEmpty(list)) { this.data[listname] = list.toString(); }
    }, this));

    this.data.referral_source = this.$("select[name=referral_source]").val();
    this.data.referral_metadata = this.$("input[name=referral_metadata]").val();

    var new_api = "/api" + this.communityExterior.links.registration[(this.data.isFacebook) ? "facebook" : "new"];
    $.post(new_api, this.data, _.bind(function(response) {
      if (response.success == "true" || response.id) {
        CommonPlace.account = new Account(response);
        if (this.hasAvatarFile && !this.data.isFacebook) {
          this.avatarUploader.submit();
        } else {
          this.nextPage("feed", this.data);
        }
      } else {
        if (!_.isEmpty(response.facebook)) {
          window.location.pathname = this.communityExterior.links.facebook_login;
        } else if (!_.isEmpty(response.password)) {
          this.$("#password_error").text(response.password[0]);
          this.$("#password_error").show();
        } else if (!_.isEmpty(response.referral_source)) {
          this.$("#referral_source_error").text(response.referral_source[0]);
          this.$("#referral_source_error").show();
        }
      }
    }, this));
  },

  skills: function() { return this.communityExterior.skills; },

  interests: function() { return this.communityExterior.interests; },

  goods: function() { return this.communityExterior.goods; },

  referrers: function() { return this.communityExterior.referral_sources; },

  initAvatarUploader: function($el) {
    var self = this;
    this.avatarUploader = new AjaxUpload($el, {
      action: "/api" + this.communityExterior.links.registration.avatar,
      name: 'avatar',
      data: { },
      responseType: 'json',
      autoSubmit: false,
      onChange: function() { self.toggleAvatar(); },
      onSubmit: function(file, extension) {},
      onComplete: function(file, response) {
        CommonPlace.account.set(response);
        self.nextPage("crop", this.data);
      }
    });
  },

  toggleAvatar: function() {
    this.hasAvatarFile = true;
    this.$("a.avatar_file_browse").html("Added a photo ✓");
  },

  initReferralQuestions: function() {
    this.$("select[name=referral_source]").bind("change", _.bind(function() {
      var question = {
        "Received a postcard from a local business": {
          text: "Which local business?",
          select_business: true
        },
        "In an email": {
          text: "Who was the email from?",
          autocomplete_people: true
        },
        "By word of mouth": {
          text: "From what person or organization?",
          autocomplete_people: true
        },
        "In the news": {
          text: "From which news source?"
        },
        "On Facebook": {
          text: "From what person or organization?",
          autocomplete_people: true
        },
        "On Twitter": {
          text: "From what person or organization?",
          autocomplete_people: true
        },
        "At an event": {
          text: "What was the event?"
        },
        "Other": "Please specify how you found out about CommonPlace."
      }[this.$("select[name=referral_source] option:selected").val()];
      if (question) {
        this.$(".referral_metadata_li").show();
        this.$(".referral_metadata_li label").html(question.text);
        if (question.autocomplete_users) {
          // TODO
          // Auto-completer for users from Organizer App
        }
        if (question.select_business) {
          // TODO
          // Display a dropdown of local business partners
        }
      } else {
        this.$(".referral_metadata_li").hide();
      }
    }, this));
  },

  facebook: function(e) {
    if (e) { e.preventDefault(); }
    facebook_connect_avatar({
      success: _.bind(function(data) {
        this.data.isFacebook = true;
        this.data = _.extend(this.data, data);
        this.template = "registration.facebook_profile";
        this.render();
      }, this)
    });
  },

  isWatertown: function() { return CommonPlace.community.get("name") == "Watertown"; }

});
