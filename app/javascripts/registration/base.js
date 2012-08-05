
var RegistrationRouter = Backbone.Router.extend({

  routes: {
    "": "new_user",
    "/": "new_user",
    "new": "new_user",
    "register/profile": "profile",
    "register/avatar": "crop",
    "register/crop": "crop",
    "register/feeds": "feed",
    "register/groups": "group",
    "register/neighbors": "neighbors",
    "*p": "new_user"
  },

  defaultRoute: function(a) {
    alert("default");
  },

  initialize: function(options) {
    this.initFacebook();

    var header = new HeaderView({ el: $("#header") });
    header.render();

    this.modal = new RegistrationModal({
      communityExterior: options.communityExterior,
      template: "registration.modal",
      complete: function() {
        window.location.pathname = options.communityExterior.links.tour;
      },
      el: $("#registration-modal")
    });
    this.modal.render();

  },

  new_user: function(a) {
    if (window.location.pathname.split("/").length > 2) {
      var url = window.location.pathname.split("/")[2];
      if (url == "about" ||
         url == "our-mission" ||
         url == "our-story" ||
         url == "our-platform" ||
         url == "press" ||
         url == "nominate") {
        this.newUserAbout();
        return;
      }
    }
    this.modal.showPage("new_user");
  },
  newUserAbout: function() {
    this.modal.showPage("new_user_about");
  },
  profile: function() { this.modal.showPage("profile"); },
  crop: function() { this.modal.showPage("crop"); },
  feed: function() { this.modal.showPage("feed"); },
  group: function() { this.modal.showPage("group"); },
  neighbors: function() { this.modal.showPage("neighbors", CommonPlace.account.toJSON()); },

  initFacebook: function() {
    var e = document.createElement('script');
    e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
    e.async = true;
    document.getElementById('fb-root').appendChild(e);
  }
});

// modal view

var RegistrationModal = CommonPlace.View.extend({
  id: "registration-modal",

  events: {
    "click #modal-whiteout": "exit"
  },

  afterRender: function() {
    this.communityExterior = this.options.communityExterior;
    this.firstSlide = true;
  },

  showPage: function(page, data) {
    var self = this;
    var nextPage = function(next, data) { self.showPage(next, data); }
    var slideIn = function(el, callback) { self.slideIn(el, callback); }

    if (!this.firstSlide) { this.slideOut(); }

    var view = {
      new_user_about: function() {
        return new AboutPageRegisterNewUserView({
          nextPage: nextPage,
          slideIn: slideIn,
          communityExterior: self.communityExterior,
          data: data
        });
      },
      new_user: function() {
        return new RegisterNewUserView({
          nextPage: nextPage,
          slideIn: slideIn,
          communityExterior: self.communityExterior,
          data: data
        });
      },
      profile: function() {
        return new RegisterProfileView({
          nextPage: nextPage,
          data: data,
          slideIn: slideIn,
          communityExterior: self.communityExterior
        });
      },
      crop: function() {
        return new RegisterCropView({
          nextPage: nextPage,
          slideIn: slideIn,
          data: data
        });
      },
      feed: function() {
        return new RegisterFeedListView({
          nextPage: nextPage,
          slideIn: slideIn,
          communityExterior: self.communityExterior,
          data: data
        });
      },
      group: function() {
        return new RegisterGroupListView({
          nextPage: nextPage,
          slideIn: slideIn,
          communityExterior: self.communityExterior,
          data: data,
          complete: self.options.complete
        });
      },
      neighbors: function() {
        return new RegisterNeighborsView({
          complete: self.options.complete,
          slideIn: slideIn,
          communityExterior: self.communityExterior,
          data: data,
          nextPage: nextPage
        });
      }
    }[page]();

    view.render();
  },

  centerEl: function() {
    var $el = this.$("#current-registration-page");
    $el.css(this.dimensions($el));
  },

  slideOut: function() {
    var $current = this.$("#current-registration-page");
    var dimensions = this.dimensions($current);

    this.slide($current,
      { left: 0 - $current.width() },
      function() {
        $current.empty();
        $current.hide();
      }
    );
  },

  slideIn: function(el, callback) {
    var $next = this.$("#next-registration-page");
    var $window = $(window);
    var $current = this.$("#current-registration-page");
    var $pagewidth = this.$("#pagewidth");

    $pagewidth.css({ top: $(this.el).offset().top });
    $next.show();
    $next.append(el);

    var dimensions = this.dimensions($next);

    $next.css({
      left: $window.width()
    });

    this.slide($next, { left: dimensions.left }, _.bind(function() {
      $current.html($next.children("div").detach());
      $current.show();
      this.centerEl();
      $next.empty();
      $next.hide();
      if (callback) { callback(); }
    }, this));
  },

  slide: function($el, ending, complete) {
    if (this.firstSlide) {
      $el.css(ending);
      this.firstSlide = false;
      return complete();
    }
    $el.animate(ending, 800, complete);
  },

  dimensions: function($el) {
    var left = ($(window).width() - $el.width()) /2;
    return { left: left };
  },

  exit: function() {
    $(this.el).remove();
  }

});

var RegistrationModalPage = CommonPlace.View.extend({
  initialize: function(options) {
    this.data = options.data || { isFacebook: false };
    this.communityExterior = options.communityExterior;
    this.slideIn = options.slideIn;
    this.nextPage = options.nextPage;
    this.complete = options.complete;

    if (options.data && options.data.isFacebook && this.facebookTemplate) {
      this.template = this.facebookTemplate;
    }
  }
});
