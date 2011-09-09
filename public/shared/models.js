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

  
var Announcement = CommonPlace.Repliable.extend({});

var Event = CommonPlace.Repliable.extend({});

var Reply = CommonPlace.Model.extend({});

var Message = CommonPlace.Model.extend({
  initialize: function(options) {
    this.feed = options.feed;
  },

  url: function() {
    return "/api" + this.feed.get("links").messages;
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
    model: Subscriber,
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
        callback();
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
        callback();
      }
    });
  }

});

var Community = CommonPlace.Model.extend({

});

var Replies = CommonPlace.Collection.extend({
  initialize: function(models, options) { this.repliable = options.repliable; },
  model: Reply,
  url: function() { return "/api" + this.repliable.get('links').replies; }
});

var Subscriber = CommonPlace.Model.extend({
  defaults: {
    first_name: "Eblong",
    last_name: "Zarf"
  }
  
});

var Group = CommonPlace.Model.extend({
  initialize: function() {
    this.posts = new Group.PostCollection([], { group: this });
    this.members = new Group.MemberCollection([], { group: this });
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
    model: GroupMember,
    url: function() { 
      return "/api" + this.group.get('links').members; 
    }
  })
});

var GroupPost = CommonPlace.Model.extend({
});

var GroupMember = CommonPlace.Model.extend({
});
