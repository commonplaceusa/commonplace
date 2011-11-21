 
var Community = Model.extend({
  initialize: function() {
    this.posts = this.setup(Posts, "posts");
    this.events = this.setup(Events, "events");
    this.announcements = this.setup(Announcements, "announcements");
    this.groupPosts = this.setup(GroupPosts, "group_posts");
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
