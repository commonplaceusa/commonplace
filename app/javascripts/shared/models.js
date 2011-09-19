CommonPlace.Model = Backbone.Model.extend({
  url: function() {
    if (this.get('links') && this.get('links').self) {
      return "/api" + this.get('links').self;
    } else {
      return Backbone.Model.prototype.url.call(this); // super
    }
  }
});

CommonPlace.Collection = Backbone.Collection.extend({});
  
CommonPlace.Repliable = CommonPlace.Model.extend({
  replies: function() {
    this._replies = this._replies || 
      new Replies(_.map(this.get('replies'), 
                        function (reply) {
                          return new Reply(reply);
                        }), 
                  { repliable: this });
    return this._replies;
  }
});

var Announcement = CommonPlace.Repliable.extend({
  author: function(callback) {
    if (!this._author) {
      this._author = new window[this.get('owner_type')]({
        links: { self: this.get('links').author }
      });
    }
    this._author.fetch({ success: callback });
  }

});

var Event = CommonPlace.Repliable.extend({});

var Reply = CommonPlace.Model.extend({
  user: function(callback) {
    if (!this._user) { 
      this._user = new User({
        links: { self: this.get("links").author }
      });
    }
    this._user.fetch({ success: callback });
  }
});

var GroupPost = CommonPlace.Repliable.extend({
  group: function(callback) {
    if (!this._group) { 
      this._group = new Group({
        links: { self: this.get("links").group }
      });
    }
    this._group.fetch({ success: callback });
  }
});
var Post = CommonPlace.Repliable.extend({
  user: function(callback) {
    if (!this._user) {
      this._user = new User({
        links: { self: this.get("links").author }
      });
    }
    this._user.fetch({ success: callback });
  }
});

var Message = CommonPlace.Model.extend({
  initialize: function(options) {
    this.messagable = options.messagable;
  },

  url: function() {
    return "/api" + this.messagable.get("links").messages;
  },

  name: function() {
    return this.messagable.get("name");
  }
});

var Feed = CommonPlace.Model.extend({
  initialize: function() {
    this.announcements = new Feed.AnnouncementCollection([], { feed: this });
    this.events = new Feed.EventCollection([], { feed: this });
    this.subscribers = new Feed.SubscriberCollection([], { feed: this });
  }
}, {
  EventCollection: CommonPlace.Collection.extend({
    initialize: function(models, options) { this.feed = options.feed; },
    model: Event, 
    url: function() { return "/api" + this.feed.get('links').events; }
  }),
  
  AnnouncementCollection :  CommonPlace.Collection.extend({
    initialize: function(models, options) { this.feed = options.feed; },
    model: Announcement,
    url: function() { 
      return "/api" + this.feed.get('links').announcements; 
    }
  }),

  SubscriberCollection: CommonPlace.Collection.extend({
    initialize: function(models, options) { this.feed = options.feed },
    model: User,
    url: function () {
      return "/api" + this.feed.get("links").subscribers;
    }
  })
});

var Account = CommonPlace.Model.extend({
  
  isFeedOwner: function(feed) {
    return _.any(this.get('accounts'), function(account) {
      return account.uid === "feed_" + feed.id;
    });
  },

  isSubscribedToFeed: function(feed) {
    return _.include(this.get('feed_subscriptions'), feed.id);
  },

  subscribeToFeed: function(feed, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get('links').feed_subscriptions,
      data: JSON.stringify({ id: feed.id }),
      type: "post",
      dataType: "json",
      success: function(account) { 
        self.set(account);
        callback && callback();
      }
    });
  },

  unsubscribeFromFeed: function(feed, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get('links').feed_subscriptions + '/' + feed.id,
      type: "delete",
      dataType: "json",
      success: function(account) { 
        self.set(account);
        callback && callback();
      }
    });
  },

  isSubscribedToGroup: function(group) {
    return _.include(this.get("group_subscriptions"), group.id);
  },

  subscribeToGroup: function(group, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").group_subscriptions,
      data: JSON.stringify({ id: group.id }),
      type: "post",
      dataType: "json",
      success: function(account) {
        self.set(account);
        callback && callback();
      }
    });
  },

  unsubscribeFromGroup: function(group, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").group_subscriptions + "/" + group.id,
      type: "delete",
      dataType: "json",
      success: function(account) {
        self.set(account);
        callback && callback();
      }
    });
  }

});

var User = CommonPlace.Model.extend({});

var Group = CommonPlace.Model.extend({
  initialize: function() {
    this.posts = new Group.PostCollection([], { group: this });
    this.members = new Group.MemberCollection([], { group: this });
    this.announcements = new Group.AnnouncementCollection([], { group: this });
    this.events = new Group.EventCollection([], { group: this });
  }
}, {
  PostCollection: CommonPlace.Collection.extend({
    initialize: function(models, options) { this.group = options.group; },
    model: GroupPost, 
    url: function() {
      return "/api" + this.group.get('links').posts;
    }
  }),
  
  MemberCollection :  CommonPlace.Collection.extend({
    initialize: function(models, options) { this.group = options.group; },
    model: User,
    url: function() { 
      return "/api" + this.group.get('links').members; 
    }
  }),

  AnnouncementCollection :  CommonPlace.Collection.extend({
    initialize: function(models, options) { this.group = options.group; },
    model: Announcement,
    url: function() { 
      return "/api" + this.group.get('links').announcements; 
    }
  }),

  EventCollection :  CommonPlace.Collection.extend({
    initialize: function(models, options) { this.group = options.group; },
    model: Event,
    url: function() { 
      return "/api" + this.group.get('links').events; 
    }
  })
});

var Community = CommonPlace.Model.extend({
  initialize: function() {
    this.posts = new Community.Posts([], { community: this });
    this.events = new Community.Events([], { community: this });
    this.announcements = new Community.Announcements([], { community: this });
    this.groupPosts = new Community.GroupPosts([], { community: this });
    this.users = new Community.Users([], { community: this });
    this.feeds = new Community.Feeds([], { community: this });
    this.groups = new Community.Groups([], { community: this });
  }
}, {
  Posts: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: Post,
    url: function() { return "/api" + this.community.get('links').posts; }
  }),

  Events: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: Event,
    url: function() { return "/api" + this.community.get('links').events; }
  }),

  Announcements: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: Announcement,
    url: function() { return "/api" + this.community.get('links').announcements; }
  }),

  GroupPosts: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: GroupPost,
    url: function() { return "/api" + this.community.get('links').group_posts; }
  }),

  Users: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: User,
    url: function() { return "/api" + this.community.get('links').users; }
  }),

  Feeds: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: Feed,
    url: function() { return "/api" + this.community.get('links').feeds; }
  }),

  Groups: CommonPlace.Collection.extend({
    initialize: function(models,options) { this.community = options.community; },
    model: Group,
    url: function() { return "/api" + this.community.get('links').groups; }
  })

});

var Replies = CommonPlace.Collection.extend({
  initialize: function(models, options) { this.repliable = options.repliable; },
  model: Reply,
  url: function() { return "/api" + this.repliable.get('links').replies; }
});




