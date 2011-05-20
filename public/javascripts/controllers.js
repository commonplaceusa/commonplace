var CommonPlace = CommonPlace || {};

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
    this.renderProfile(this.community.events.get(id), "eventinfo");
  },

  user: function(id) {
    this.renderProfile(this.community.users.get(id), "userinfo");
  },

  feed: function(id) {
    var view = new CommonPlace.FeedInfo({el: $("#community-profiles"),
                                          model: this.community.feeds.get(id)});
    view.render()
  },

  group: function(id) {
    var view = new CommonPlace.GroupInfo({el: $("#community-profiles"),
                                          model: this.community.groups.get(id)});
    view.render()
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
    new CommonPlace.SaySomething({el: $("#say-something")});
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
    "": "wire"
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
                  return _.extend(nav, {current: current_url == nav.url})
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

