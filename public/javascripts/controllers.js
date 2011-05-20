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
    "/": "wire"
  },


  posts: function() {
    this.postIndex = this.postIndex ||
      new CommonPlace.Index({collection: this.community.posts,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.PostItem,
                             subnav: "<a href=\"/posts\" class=\"current\">Neighborhood Posts</a>",
                             zone: "posts"
                            });
    this.postIndex.render();
  },
  announcements: function(){
    this.announcementIndex = this.announcementIndex ||
      new CommonPlace.Index({collection: this.community.announcements,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.AnnouncementItem,
                             subnav: "<a href=\"/announcements\" class=\"current\">Community Announcements</a> &sdot; <a href=\"/feeds\">Community Feeds</a>",
                             zone: "announcements"
                            });


    this.announcementIndex.render();
  },
  events: function(){
    this.eventIndex = this.eventIndex ||
      new CommonPlace.Index({collection: this.community.events,
                             el:$("#whats-happening"),
                             itemView: CommonPlace.EventItem,
                             subnav: "<a href=\"/events\" class=\"current\">Upcoming Events</a>",
                             zone: "events"
                            });
    this.eventIndex.render();
  },

  group_posts: function(){
    this.group_postIndex = this.group_postIndex ||
      new CommonPlace.Index({collection: this.community.group_posts,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.GroupPostItem,
                             subnav: "<a href=\"/group_posts\" class=\"current\">Group Posts</a> &sdot; <a href=\"/groups\">Discussion Groups</a>",
                             zone: "group_posts"
                            });
    this.group_postIndex.render();
  },

  groups: function(){
    this.groupIndex = this.groupIndex ||
      new CommonPlace.Index({collection: this.community.groups,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.GroupItem,
                             subnav: "<a href=\"/users\">Your Neighbors</a> &sdot; <a href=\"/feeds\">Community Feeds</a> &sdot; <a href=\"/groups\" class=\"current\">Discussion Groups</a>",
                             zone: "users"
                            });
    this.groupIndex.render();
  },
  feeds: function(){
    this.feedIndex = this.feedIndex ||
      new CommonPlace.Index({collection: this.community.feeds,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.FeedItem,
                             subnav: "<a href=\"/users\">Your Neighbors</a> &sdot; <a href=\"/feeds\" class=\"current\">Community Feeds</a> &sdot; <a href=\"/groups\">Discussion Groups</a>",
                             zone: "users"
                            });
    this.feedIndex.render();
  },
  users: function(){
    this.userIndex = this.userIndex ||
      new CommonPlace.Index({collection: this.community.users,
                             el: $("#whats-happening"),
                             itemView: CommonPlace.UserItem,
                             subnav: "<a href=\"/users\" class=\"current\">Your Neighbors</a> &sdot; <a href=\"/feeds\">Community Feeds</a> &sdot; <a href=\"/groups\">Discussion Groups</a>",
                             zone: "users"
                            });
    this.userIndex.render();
  }
  
});

