
var Account = Model.extend({
  
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
  },

  meetUser: function(user, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").mets,
      data: JSON.stringify({ id: user.id }),
      type: "post",
      dataType: "json",
      success: function(account) {
        self.set(account);
        callback && callback();
      },
      failure: function(account) {
        console.log(self, user);
      }
    });
  },

  unmeetUser: function(user, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").mets + "/" + user.id,
      type: "delete",
      dataType: "json",
      success: function(account) {
        self.set(account);
        callback && callback();
      }
    });
  },

  hasMetUser: function(user) {
    return _.include(this.get("mets"), user.id);
  }

});
