var ApplicationOrNominationSubmittedView = CommonPlace.View.extend({
  template: "registration.application_or_nomination_submitted",

  events: {
    "click .register-button": "register",
    "click .facebook": "share_on_facebook"
  },

  applying: function() {
    return this.options.applying_or_nominating == "applying";
  },

  nominating: function() {
    return this.options.applying_or_nominating == "nominating";
  },

  nominee_name: function() { return this.options.nominee_name; },

  nominee_first_name: function() {
    if (this.options.nominee_name.indexOf(" ") != -1) {
      return this.options.nominee_name.split(" ")[0];
    } else {
      return this.options.nominee_name;
    }
  },

  register: function() {
    var community_slug = CommonPlace.community.get("slug");
    var about_page_url = "/" + community_slug + "/about";
    window.location = about_page_url;
  },

  share_on_facebook: function(e) {
    e && e.preventDefault();
    FB.ui(
    {
      method: 'feed',
      name: 'OurCommonPlace Civic Hero Nomination',
      link: 'https://' + CommonPlace.community.get("slug") + '.ourcommonplace.com/nominate',
      description: 'I just nominated my neighbor for a Civic Hero Award on the ' + CommonPlace.community.get("name") + ' CommonPlace!',
      display: 'popup',
      redirect_uri: 'https://www.ourcommonplace.com/close_dialog'
    },
    function(response) { FB.Dialog.remove(FB.Dialog._active); }
  );
  }

});
