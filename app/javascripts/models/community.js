 
var Community = Model.extend({
  initialize: function() {
    this.posts = this.setup(Posts, "posts");
    this.events = this.setup(Events, "events");
    this.announcements = this.setup(Announcements, "announcements");
    this.groupPosts = this.setup(GroupPosts, "group_posts");
    this.postlikes = this.setup(PostLikes, "post_likes");
    this.users = this.setup(Users, "users");
    this.feeds = this.setup(Feeds, "feeds");
    this.groups = this.setup(Groups, "groups");
    this.search = {
      users: this.setup(Users, "users"),
      feeds: this.setup(Feeds, "feeds"),
      groups: this.setup(Groups, "groups"),
      groupPosts: this.setup(GroupPosts, "group_posts"),
      posts: this.setup(Posts, "posts"),
      announcements: this.setup(Announcements, "announcements"),
      events: this.setup(Events, "events")
    }
    this.categories = {
      neighborhood: this.setup(Posts, "posts_neighborhood"),
      offers: this.setup(Posts, "posts_offers"),
      help: this.setup(Posts, "posts_help"),
      publicity: this.setup(Posts, "posts_publicity"),
      other: this.setup(Posts, "posts_other")
    }
  },
  
  setup: function(collectionClass, url) {
    return new collectionClass([], { uri: this.link(url) });
  }
});

// a fake collection for post-likes, because the id #'s collide
var PostLikes = Model.extend({
  initialize: function(blank, options) {
    this.uri = "/api" + options.uri;
  },
  
  fetch: function(options) {
    var self = this;
    $.getJSON(this.uri, options.data, function(data) {
      self.models = _.map(data, function(d) { return self.toModel(d); });
      self.length = data.length;
      options.success && options.success();
    });
  },
  
  each: function(callback) {
    _.each(this.models, function(model) {
      callback(model);
    });
  },
  
  toModel: function(data) {
    var x = new {
      "events": Event,
      "announcements": Announcement,
      "posts": Post,
      "group_posts": GroupPost
    }[data.schema](data);
    return x;
  },
  
  length: 0,
  
  isEmpty: function() {
    console.log(this.models.length);
    return this.models.length == 0;
  },
  
  remove: function(targets) {
    this.models = _.filter(this.models, function(model) {
      var isTarget = _.any(targets, function(target) {
        return target.id == model.id && target.get("schema") == model.get("schema");
      });
      return !isTarget;
    });
    this.length = this.models.length;
  }
});
