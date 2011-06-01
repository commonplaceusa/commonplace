var CommonPlace = CommonPlace || {};

CommonPlace.SaySomethingController = Backbone.Controller.extend({
  
  initialize: function(options) {
    this.view = new CommonPlace.SaySomething({el: $("#say-something")});
    this.newPost();
  },

  routes: {
    "/posts/new" : "newPost",
    "/events/new" : "newEvent",
    "/announcements/new" : "newAnnouncement",
    "/group_posts/new" : "newGroupPost"
  },

  newPost : function() { 
    this.view.template = "post_form";
    this.view.model = new CommonPlace.Post({},{collection: CommonPlace.community.posts });
    this.view.render();
  },
  
  newEvent : function() {
    this.view.template = "event_form";
    this.view.model = new CommonPlace.Event({},{collection: CommonPlace.community.events });
    this.view.render();
  },
  
  newAnnouncement : function() { 
    this.view.template = "announcement_form";
    this.view.model = new CommonPlace.Announcement({}, {collection: CommonPlace.community.announcements });
    this.view.render();
  },

  newGroupPost : function() { 
    this.view.template = "group_post_form";
    this.view.model = new CommonPlace.GroupPost({}, {collection: CommonPlace.community.group_posts});
    this.view.render();
  }

});
CommonPlace.ProfileController = Backbone.Controller.extend({
  initialize: function(options) {
    this.community = options.community;
    this.profile = new CommonPlace.Info({el: $("#community-profiles")});
  },
  
  routes: {
    "/events/:id/info": "event",
    "/users/:id/info": "user",
    "/groups/:id/info": "group",
    "/feeds/:id/info": "feed"
  },

  event: function(id) {
    var view = new CommonPlace.EventInfo({el: $("#community-profiles"),
                                          model: this.community.events.get(id)});
    view.render();
  },

  user: function(id) {
    this.renderProfile(this.community.users.get(id), "userinfo");
  },

  feed: function(id) {
    var view = new CommonPlace.FeedInfo({el: $("#community-profiles"),
                                          model: this.community.feeds.get(id)});
    view.render();
  },

  group: function(id) {
    var view = new CommonPlace.GroupInfo({el: $("#community-profiles"),
                                          model: this.community.groups.get(id)});
    view.render();      
  },

  renderProfile: function(model, template) {
    this.profile.model = model;
    this.profile.template = template;
    this.profile.render();
  }
  
});

CommonPlace.WhatsHappeningController = Backbone.Controller.extend({
  initialize: function(options) {
    this.community = options.community;
    new CommonPlace.Index({el: $("#whats-happening")});
    return this;
  },

  routes: {
    "/events": "events",
    "/announcements": "announcements",
    "/posts": "posts",
    "/group_posts" : "group_posts",

    "/users": "users",
    "/feeds": "feeds",
    "/groups": "groups",
    "/": "wire",
    "": "routeFromPathName",
    "/posts/:id": "showPost",
    "/announcements/:id": "showAnnouncement",
    "/group_posts/:id": "showGroupPost",
    "/events/:id": "showEvent",
    "/users/:id": "showUser",
    "/feeds/:id": "showFeed",
    "/groups/:id": "showGroup"
  },

  routeFromPathName: function() {
    if (window.location.pathname == "/") {
      this.wire();
    } else {
      window.location.hash = window.location.pathname;
    }
  },
  
  wire: function() {
    (new CommonPlace.Wire({model: this.community,
                           el: $("#whats-happening")})).render();
    
  },

  posts: function() {
    this.postIndex = this.postIndex ||
      new CommonPlace.Index({
        collection: this.community.posts,
        el: $("#whats-happening"),
        itemView: CommonPlace.PostItem,
        subnav: [{url: "/posts", current: true, last: true, name: "Neighborhood Posts"}],
        zone: "posts"
      });
    this.postIndex.render();
  },
  
  showPost: function(id) { this.posts(); 
                           $.scrollTo($("#post-" + id + "-item"));
                         },
  showAnnouncement: function(id) { this.announcements();
                                   $.scrollTo($("#announcement-" + id + "-item"));
                                 },
  showGroupPost: function(id) { this.group_posts();
                                $.scrollTo($("#group_post-" + id + "-item")); 
                              },
  showEvent: function(id) { this.events();
                            $.scrollTo($("#event-" + id + "-item"));
                          },
  showUser: function(id) { this.users();
                           $.scrollTo($("#user-" + id + "-item"));
                         },
  showFeed: function(id) { this.feeds();
                           $.scrollTo($("#feed_" + id + "_item"));
                         },
  showGroup: function(id) { this.groups();
                            $.scrollTo($("#group_" + id + "_item"));
                          },

  announcements: function(){
    this.announcementIndex = this.announcementIndex ||
      new CommonPlace.Index({
        collection: this.community.announcements,
        el: $("#whats-happening"),
        itemView: CommonPlace.AnnouncementItem,
        subnav: [{url:"/announcements", name:"Community Announcements", current: true},
                 {url:"/feeds", name: "Community Feeds", last:true}],
        zone: "announcements"
      });
    this.announcementIndex.render();
  },

  events: function(){
    this.eventIndex = this.eventIndex ||
      new CommonPlace.Index({
        collection: this.community.events,
        el:$("#whats-happening"),
        itemView: CommonPlace.EventItem,
        subnav: [{url: "/events", name:"Upcoming Events", current: true, last: true}],
        zone: "events"
      });
    this.eventIndex.render();
  },

  group_posts: function(){
    this.group_postIndex = this.group_postIndex ||
      new CommonPlace.Index({
        collection: this.community.group_posts,
        el: $("#whats-happening"),
        itemView: CommonPlace.GroupPostItem,
        subnav: [{url: "/group_posts", name: "Group Posts", current: true},
                 {url: "/groups", name: "Discussion Groups", last: true}],
        zone: "group_posts"
      });
    this.group_postIndex.render();
  },

  directorySubnav: function(current_url) {
    return _([{url: "/users", name: "Your Neighbors"},
              {url: "/feeds", name: "Community Feeds"},
              {url: "/groups", name: "Discussion Groups", last: true}]).map(
                function(nav) {
                  return _.extend(nav, {current: current_url == nav.url});
                });
  },

  groups: function(){
    this.groupIndex = this.groupIndex ||
      new CommonPlace.Index({
        collection: this.community.groups,
        el: $("#whats-happening"),
        itemView: CommonPlace.GroupItem,
        subnav: this.directorySubnav("/groups"),
        zone: "users"
      });
    this.groupIndex.render();
  },

  feeds: function(){
    this.feedIndex = this.feedIndex ||
      new CommonPlace.Index({collection: this.community.feeds,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.FeedItem,
                             subnav: this.directorySubnav("/feeds"),
                             zone: "users"
                            });
    this.feedIndex.render();
  },
  users: function(){
    this.userIndex = this.userIndex ||
      new CommonPlace.Index({collection: this.community.users,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.UserItem,
                             subnav: this.directorySubnav("/users"),
                             zone: "users"
                            });
    this.userIndex.render();
  }

    
  
});

