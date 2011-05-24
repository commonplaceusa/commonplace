var CommonPlace = CommonPlace || {};

CommonPlace.Community = Backbone.Model.extend({
  initialize: function(options) {
    this.users = new CommonPlace.Users([],{community: this});
    this.events = new CommonPlace.Events([],{community: this});
    this.posts = new CommonPlace.Posts([],{community: this});
    this.announcements = new CommonPlace.Announcements([], {community: this});
    this.group_posts = new CommonPlace.GroupPosts([], {community: this});
    this.feeds = new CommonPlace.Feeds([], {community: this});
    this.groups = new CommonPlace.Groups([], {community: this});
    return this;
  }
});

CommonPlace.Account = Backbone.Model.extend({});

CommonPlace.User = Backbone.Model.extend({});

CommonPlace.Users = Backbone.Collection.extend({
  model: CommonPlace.User,
  
  initialize: function(models,options) {
    this.community = options.community;
    return this;
  },

  comparator: function(user) { return user.get('last_name') + user.get('first_name'); },

  url: function() {
    return "/api/communities/" + this.community.id + "/users";
  }
});

CommonPlace.Post = Backbone.Model.extend({

  initialize: function(attrs, options) {
    this.community = this.collection.community;
    this.user = this.community.users.get(this.get('user_id'));
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});
  }
    
});

CommonPlace.Posts = Backbone.Collection.extend({
  
  model: CommonPlace.Post,

  comparator: function(model) { return - CommonPlace.parseDate(model.get("published_at")) ; },

  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  url: function() {
    return "/api/communities/" + this.community.id + "/posts"
  }
});

CommonPlace.Event = Backbone.Model.extend({

  monthAbbrevs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],

  initialize: function(attrs, options) {
    this.community = this.collection.community;
    var date = new Date(CommonPlace.parseDate(this.get("occurs_on")));
    this.set({"day_of_month": date.getDate(),
              "abbrev_month": this.monthAbbrevs[date.getMonth()]});
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});

  }

});

CommonPlace.Events = Backbone.Collection.extend({
  model: CommonPlace.Event,

  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  comparator: function(model) { return CommonPlace.parseDate(model.get("occurs_on")); },

  url: function() {
    return "/api/communities/" + this.community.id + "/events"
  }
});


CommonPlace.Feed = Backbone.Model.extend({});

CommonPlace.Feeds = Backbone.Collection.extend({
  model: CommonPlace.Feed,
  
  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  comparator: function(feed) { return feed.get('name'); },

  url: function() {
    return "/api/communities/" + this.community.id + "/feeds";
  }
});

CommonPlace.Announcement = Backbone.Model.extend({

  initialize: function(attrs, options) {
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
  }

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

CommonPlace.Group = Backbone.Model.extend({});

CommonPlace.Groups = Backbone.Collection.extend({
  model: CommonPlace.Group,
  
  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  comparator: function(group) { return group.get('name'); },

  url: function() {
    return "/api/communities/" + this.community.id + "/groups";
  }

});

CommonPlace.GroupPost = Backbone.Model.extend({

  initialize: function(attrs, options) {
    this.community = this.collection.community;
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});
  },

  group: function() {
    this._group = this._group ||
      this.community.groups.get(this.get('group_id'));
    return this._group;
  }

});

CommonPlace.GroupPosts = Backbone.Collection.extend({
  model: CommonPlace.GroupPost,

  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  url: function() {
    return "/api/communities/" + this.community.id + "/group_posts";
  },

  comparator: function(model) { return - CommonPlace.parseDate(model.get("published_at")) ; }

});

CommonPlace.Reply = Backbone.Model.extend({});

CommonPlace.Replies = Backbone.Collection.extend({

  model: CommonPlace.Reply,
  
  initialize: function(models, options) {
    this.repliable = options.repliable;
  },

  url: function() { return this.repliable.url() + "/replies" },

  comparator: function(reply) { return CommonPlace.parseDate(reply.get("published_at")); }

});
