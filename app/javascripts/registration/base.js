
var RegistrationRouter = Backbone.Router.extend({

  routes: {
    "": "new_user",
    "/": "new_user",
    "/new": "new_user",
    "/profile": "profile",
    "/avatar": "crop",
    "/crop": "crop",
    "/feeds": "feed",
    "/groups": "group",
    "/neighbors": "neighbors"
  },
  
  initialize: function(options) {
    this.initFacebook();
  
    this.modal = new RegistrationModal({
      communityExterior: options.communityExterior,
      template: "registration.modal",
      finish: function() {
        window.location.pathname = options.communityExterior.links.tour;
      },
      el: $("#registration-modal")
    });
    this.modal.render();
    
    var communitySlug = window.location.pathname.split("/")[1];
    Backbone.history.start({ pushState: true, root: "/" + communitySlug });
  },
  
  new_user: function() { this.modal.showPage("new_user"); },
  profile: function() { this.modal.showPage("profile"); },
  crop: function() { this.modal.showPage("crop"); },
  feed: function() { this.modal.showPage("feed"); },
  group: function() { this.modal.showPage("group"); },
  neighbors: function() { this.modal.showPage("neighbors"); },
  
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
    
    if (!this.firstSlide) { this.slideOut(); }
    
    var view = {
      new_user: function() {
        return new RegisterNewUserView({
          nextPage: nextPage,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior,
          data: data
        });
      },
      profile: function() {
        return new RegisterProfileView({
          nextPage: nextPage,
          data: data,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior
        });
      },
      crop: function() {
        return new RegisterCropView({
          nextPage: nextPage,
          slideIn: function(el) { self.slideIn(el); },
          data: data
        });
      },
      group: function() {
        return new RegisterGroupListView({
          nextPage: nextPage,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior,
          data: data
        });
      },
      neighbors: function() {
        return new RegisterNeighborsView({
          finish: self.options.finish,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior,
          data: data
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
      { opacity: 0, left: 0 - $current.width() },
      function() {
        $current.empty();
        $current.hide();
      }
    );
  },
  
  slideIn: function(el) {
    var $next = this.$("#next-registration-page");
    var $window = $(window);
    var $current = this.$("#current-registration-page");
    var $pagewidth = this.$("#pagewidth");
    
    $pagewidth.css({ top: $(this.el).offset().top });
    $next.show();
    $next.append(el);
    
    var dimensions = this.dimensions($next);
    
    $next.css({
      left: $window.width(),
      opacity: 0
    });
    
    this.slide($next, { opacity: 1, left: dimensions.left }, _.bind(function() {
      $current.html($next.children("div").detach());
      $current.show();
      $current.css({
        opacity: 1
      });
      this.centerEl();
      $next.empty();
      $next.hide();
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
