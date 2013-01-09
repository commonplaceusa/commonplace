
var Account = Model.extend({

  initialize: function() {
    if (this.isAuth()) {
      this.featuredUsers = new Users([], { uri: this.link("featured_users") });
    }
  },

  profileHistory: function(callback) {
    $.ajax({
      type: "GET",
      contentType: "application/json",
      url: "/api" + this.link('history'),
      success: callback
    });
  },

  neighborhoodsPosts: function() {
    return new Posts([], { uri: this.link('neighborhoods_posts') });
  },

  isFeedOwner: function(feed) {
    return _.any(this.get('accounts'), function(account) {
      return account.uid === "feed_" + feed.id;
    });
  },

  isSubscribedToFeed: function(feed) {
    return _.include(this.get('feed_subscriptions'), feed.id);
  },

  subscribeToFeed: function(feed, callback) {
    var feed_ids = (_.isArray(feed)) ? feed : feed.id;
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get('links').feed_subscriptions,
      data: JSON.stringify({ id: feed_ids }),
      type: "post",
      dataType: "json",
      success: function(account) {
        self.set(account);
        if (callback) { callback(); }
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
        if (callback) { callback(); }
      }
    });
  },

  isSubscribedToGroup: function(group) {
    return _.include(this.get("group_subscriptions"), group.id);
  },

  subscribeToGroup: function(group, callback) {
    var group_ids = (_.isArray(group)) ? group : group.id;
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").group_subscriptions,
      data: JSON.stringify({ id: group_ids }),
      type: "post",
      dataType: "json",
      success: function(account) {
        self.set(account);
        if (callback) { callback(); }
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
        if (callback) { callback(); }
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
        if (callback) { callback(); }
      },
      failure: function(account) {      }
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
        if (callback) { callback(); }
      }
    });
  },

  hasMetUser: function(user) {
    return _.include(this.get("mets"), user.id);
  },

  canEditPost: function(post) {
    return post.get('user_id') == this.id || this.get('is_admin');
  },

  canEditGroupPost: function(post) {
    return post.get('user_id') == this.id || this.get('is_admin');
  },

  canEditEvent: function(event) {
    if (this.get('is_admin')) { return true; }
    if (event.get('owner_type') == "Feed") {
      return _.include(_.pluck(this.get('feeds'), 'id'), event.get('feed_id'));
    } else {
      return event.get('user_id') == this.id;
    }
  },

  canEditAnnouncement: function(post) {
    if (this.get('is_admin')) { return true; }
    if (post.get('owner_type') == "Feed") {
      return _.include(_.pluck(this.get('feeds'), 'id'), post.get('feed_id'));
    } else {
      return post.get('user_id') == this.id;
    }
  },

  canEditReply: function(reply) {
    return reply.get("author_id") == this.id || this.get("is_admin");
  },

  canTryFeatures: function() { return this.get('is_admin'); },

  canEditTransaction: function(transaction) {
    return transaction.get('user_id') == this.id || this.get('is_admin');
  },
  deleteAvatar: function(callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get('links').avatar,
      type: "delete",
      dataType: "json",
      success: function(account) {
        self.set(account);
        if (callback) {
          callback();
        }
      }
    });
  },

  cropAvatar: function(coords, callback) {
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").crop,
      type: "put",
      dataType: "json",
      data: JSON.stringify({
        crop_x: coords.crop_x,
        crop_y: coords.crop_y,
        crop_w: coords.crop_w,
        crop_h: coords.crop_h
      }),
      success: _.bind(function(account) {
        this.set(account);
        if (callback) { callback(); }
      }, this)
    });
  },

  set_metadata: function(key, value, callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api/account/metadata",
      type: "post",
      data: JSON.stringify({ key: key, value: value }),
      dataType: "json",
      success: function(account) {
        self.set(account);
        if (callback) { callback(); }
      }
    });
  },

  clicked_post_box: function(first_click_callback) {
    if (!(this.get("metadata").has_used_postbox)) {
      if (first_click_callback) { first_click_callback(); }
      this.set_metadata('has_used_postbox', true, function() { });
    }
  },

  isAuth: function() { return !_.isEmpty(this.attributes); }

});
