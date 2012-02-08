
var RegistrationRouter = Backbone.Router.extend({

  routes: {
    "/new": "new_user",
    "/profile": "profile",
    "/avatar": "crop",
    "/crop": "crop",
    "/feeds": "feed",
    "/groups": "group"
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
  group: function() { this.modal.showPage("group"); }
});

// modal view

var RegistrationModal = CommonPlace.View.extend({
  id: "registration-modal",
  
  events: {
    "click #modal-whiteout": "exit"
  },
  
  afterRender: function() {
    this.communityExterior = this.options.communityExterior;
    this.showPage("new_user");
  },
  
  showPage: function(page, data) {
    var self = this;
    var nextPage = function(next, data) { self.showPage(next, data); }
    
    this.slideOut();
    
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
          referrer: self.options.referrer,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior
        });
      },
      group: function() {
        return new RegisterGroupListView({
          completion: self.options.completion,
          referrer: self.options.referrer,
          slideIn: function(el) { self.slideIn(el); },
          communityExterior: self.communityExterior
        });
      }
    }[page]();
    
    view.render();
    
    this.$("select.list").chosen();
  },
  
  centerEl: function() {
    var $el = this.$("#current-registration-page");
    $el.css(this.dimensions($el));
  },
  
  slideOut: function() {
    var $current = this.$("#current-registration-page");
    var dimensions = this.dimensions($current);
    
    $current.css({ position: "fixed" });
    
    $current.animate(
      { opacity: 0, left: 0 - $current.width() },
      {
        step: _.bind(function() {
          $current.css({
            left: parseInt($current.css("left")) - 10,
            opacity: parseFloat($current.css("opacity")) - 0.04
          });
        }, this),
        
        complete: function() {
          $current.empty();
          $current.css({ position: "static" });
          $current.hide();
        }
      }
    );
  },
  
  slideIn: function(el) {
    var $next = this.$("#next-registration-page");
    var $window = $(window);
    var $current = this.$("#current-registration-page");
    var $pagewidth = this.$("#pagewidth");
    
    $pagewidth.css({ position: "fixed" });
    $next.show();
    $next.append(el);
    
    var dimensions = this.dimensions($next);
    
    $next.css({
      top: dimensions.top,
      left: $window.width(),
      opacity: 0
    });
    
    $next.animate(
      { opacity: 1, left: dimensions.left },
      {
        step: _.bind(function() {
          $next.css({
            left: parseInt($next.css("left")) - 10,
            opacity: parseFloat($next.css("opacity")) + 0.04
          });
        }, this),
        
        complete: _.bind(function() {
          $current.html($next.children("div").detach());
          $current.show();
          $current.css({
            opacity: 1,
            position: "static"
          });
          this.centerEl();
          $pagewidth.css({ position: "static" });
          $next.empty();
          $next.hide();
        }, this)
      }
    );
  },
  
  dimensions: function($el) {
    var $window = $(window);
    var scrolled = $window.scrollTop();
    var top = (($window.height() - $el.height()) /2) + scrolled;
    top = top < 1 ? 10 : top;
    top = top < scrolled + 10 ? scrolled + 10 : top;
    var left = ($window.width() - $el.width()) /2;
    return { left: left, top: $("#main").offset().top };
  },
  
  exit: function() {
    $(this.el).remove();
  }
  
});
