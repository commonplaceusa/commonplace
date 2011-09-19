var InfoBoxManager = CommonPlace.View.extend({

  initialize: function(options) {
    var self = this;
    $(window).scroll(function() {
      self.setPosition();
    });
  },

  infoBoxId: "#info-box",
  
  setPosition: function() {
    var $el = $(this.infoBoxId);
    var marginTop = parseInt($el.css("margin-top"), 10);
    var $parent = $el.parent();
    var topScroll = $(window).scrollTop();
    var distanceFromTop = $el.offset().top;
    var parentBottomDistanceToTop = $parent.offset().top + $parent.height();

    $el.css({ width: $el.width() }); 

    if ($el.css("position") == "relative") {
      if (distanceFromTop < topScroll) {
        $el.css({ position: "fixed", top: 0 });
      }
    } else {
      if (distanceFromTop < parentBottomDistanceToTop + marginTop) {
        $el.css({ position: "relative" });
      }
    }
  },

  show: function(newInfoBox) { 
    this.model = newInfoBox; 
    this.model.render();
    $(this.infoBoxId).replaceWith(this.model.el);
    this.setPosition();
  }
  
});

var MainPageView = CommonPlace.View.extend({
  template: "main_page/main-page",
  id: "main",

  initialize: function(options) {
    this.account = this.options.account;
    this.community = this.options.community;
    
    this.postBox = new PostBox({ 
      account: this.account,
      community: this.community
    });
    
    this.accountInfoBox = new AccountInfoBox({
      model: this.account
    });

    this.lists = new CommunityResources({
      account: this.account,
      community: this.community
    });

    window.infoBoxManager = new InfoBoxManager({
      model: this.accountInfoBox
    })

    this.views = [this.postBox, this.accountInfoBox, this.lists];
  },

  afterRender: function() {
    var self = this;
    _(this.views).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  }

});

var MainPageRouter = Backbone.Router.extend({

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    
    this.view = new MainPageView({
      account: this.account,
      community: this.community
    });
    
    this.view.render();

    this.lists = this.view.lists;
    this.postBox = this.view.postBox;

    $("#main").replaceWith(this.view.el);
  },

  routes: {
    "/": "landing",
    "": "landing",
    "/posts": "posts",
    "/announcements": "announcements",
    "/events": "events",
    "/group_posts": "groupPosts",
    "/users": "users",
    "/feeds": "feeds",
    "/groups": "groups",
    "/new-neighborhood-post": "newPost",
    "/new-announcement": "newAnnouncement",
    "/new-event": "newEvent",
    "/new-group-post": "newGroupPost",

    "/tour": "tour"
  },

  posts: function() { this.lists.switchTab("posts"); },
  events: function() { this.lists.switchTab("events"); },
  announcements: function() { this.lists.switchTab("announcements"); },
  groupPosts: function() { this.lists.switchTab("groupPosts"); },
  users: function() { this.lists.switchTab("users"); },
  feeds: function() { this.lists.switchTab("feeds"); },
  groups: function() { this.lists.switchTab("groups"); },
  landing: function() { this.lists.switchTab("landing"); },

  newPost: function() { this.postBox.switchTab("create-neighborhood-post"); },
  newAnnouncement: function() { this.postBox.switchTab("create-announcement"); },
  newEvent: function() { this.postBox.switchTab("create-event"); },
  newGroupPost: function() { this.postBox.switchTab("create-group-post"); },

  tour: function() { 
    var tour = new Tour({ 
      el: $("#main"), 
      account: this.account, 
      community: this.community 
    });
    tour.render();
  }
});

