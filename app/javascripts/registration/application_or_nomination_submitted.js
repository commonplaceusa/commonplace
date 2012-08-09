var ApplicationOrNominationSubmittedView = CommonPlace.View.extend({
  template: "registration.application_or_nomination_submitted",

  events: {
    "click .register-button": "register"
  },

  applying: function() {
    return this.options.applying_or_nominating == "applying";
  },

  nominating: function() {
    return this.options.applying_or_nominating == "nominating";
  },

  register: function() {
    var community_slug = CommonPlace.community.get("slug");
    var about_page_url = "/" + community_slug + "/about";
    window.location = about_page_url;
  }

});
