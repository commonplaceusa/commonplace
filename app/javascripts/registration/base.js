
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
    "/facebook": "facebook"
  },
  
  initialize: function(options) {
    this.modal = new RegistrationModal({
      communityExterior: options.communityExterior,
      template: "registration.modal",
      completion: function() {
        window.location.pathname = options.communityExterior.links.tour;
      },
      el: $("#registration-modal")
    });
    this.modal.render();
  },
  
  new_user: function() { this.modal.showPage("new_user"); },
  profile: function() { this.modal.showPage("profile"); },
  crop: function() { this.modal.showPage("crop"); },
  feed: function() { this.modal.showPage("feed"); },
  group: function() { this.modal.showPage("group"); },
  facebook: function() { this.modal.showPage("facebook"); }
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
          communityExterior: self.communityExterior
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
          slideIn: function(el) { self.slideIn(el); }
        });
      },
      feed: function() {
        return new RegisterFeedListView({
          nextPage: nextPage,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior
        });
      },
      group: function() {
        return new RegisterGroupListView({
          completion: self.options.completion,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior
        });
      },
      facebook: function() {
        return new RegisterFacebookView({
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior
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
    $el.animate(ending, {
      complete: complete,
      step: function() {
        var opacityChange = (ending.opacity == 1) ? 0.04 : -0.04;
        $el.css({
          left: parseInt($el.css("left")) - 10,
          opacity: parseFloat($el.css("opacity")) + opacityChange
        });
      }
    });
  },
  
  dimensions: function($el) {
    var left = ($(window).width() - $el.width()) /2;
    return { left: left };
  },
  
  exit: function() {
    $(this.el).remove();
  }
  
});
