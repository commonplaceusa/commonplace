CommonPlace.Model = Backbone.Model.extend({

});

CommonPlace.Collection = Backbone.Collection.extend({});

var Announcement = CommonPlace.Model.extend({});

var Event = CommonPlace.Model.extend({});

var Feed = CommonPlace.Model.extend({
  initialize: function() {
    this.announcements = new Feed.AnnouncementCollection([], { feed: this });
    this.events = new Feed.EventCollection([], { feed: this });
  },
}, {
  EventCollection: CommonPlace.Collection.extend({
    initialize: function(models, options) { this.feed = options.feed },
    model: Event, 
    url: function() { return "/api" + this.feed.get('links').events }
  }),
  
  AnnouncementCollection :  CommonPlace.Collection.extend({
    initialize: function(models, options) { this.feed = options.feed },
    model: Announcement,
    url: function() { return "/api" + this.feed.get('links').announcements }
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

