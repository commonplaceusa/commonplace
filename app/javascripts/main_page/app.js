var InfoBoxManager = CommonPlace.View.extend({

  infoBoxId: "#info-box",
  profileId: "#profile",

  show: function(newProfile) { 
    this.profile = newProfile; 
    this.profile.render();
    $(this.profileId).replaceWith(this.profile.el);
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

    this.lists = new CommunityResources({
      account: this.account,
      community: this.community
    });

    this.infoBox = new InfoBox({
      account: this.account,
      community: this.community
    });

    window.infoBoxManager = new InfoBoxManager({
      account: this.account,
      community: this.community,
      model: this.infoBox
    });

    this.views = [this.postBox, this.lists, this.infoBox];
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
    this.infoBox = this.view.infoBox;

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

    "/posts/:id": "post",
    "/events/:id": "event",
    "/group_posts/:id": "groupPost",
    "/announcements/:id": "announcement",
    
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

  post: function(id) {
    this.lists.showPost(new Post({links: {self: "/posts/" + id}}));
  },
  
  event: function(id) { 
    this.lists.showEvent(new Event({links: {self: "/events/" + id }}));
  },
  
  announcement: function(id) {
    this.lists.showAnnouncement(new Event({links: {self: "/announcements/" + id}}));
  },

  groupPost: function(id) {
    this.lists.showGroupPost(new GroupPost({links: {self: "/group_posts/" + id}}));
  },
    
  tour: function() { 
    var tour = new Tour({ 
      el: $("#main"), 
      account: this.account, 
      community: this.community 
    });
    tour.render();
  }
});

