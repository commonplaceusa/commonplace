
CommonPlace.Announcement = Backbone.Model.extend({

  initialize: function(attrs, options) {
    this.collection || (this.collection = options.collection);
    this.community = this.collection.community;
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});
  },

  user: function() {
    this._user = this._user || this.community.users.get(this.get('user_id'));
    return this._user;
  },

  feed: function() {
    this._feed = this._feed || this.community.feeds.get(this.get('feed_id'));
    return this._feed;
  },

  url: function() { return this.isNew() ? "/api/announcements" : "/api/announcements/" + this.id; }

});

CommonPlace.Announcements = Backbone.Collection.extend({
  model: CommonPlace.Announcement,

  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  url: function() {
    return "/api/communities/" + this.community.id + "/announcements";
  },

  comparator: function(model) { return - CommonPlace.parseDate(model.get("published_at")) ; }
});
