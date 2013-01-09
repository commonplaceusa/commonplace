 
var Community = Model.extend({
  initialize: function() {
    this.posts = this.setup(Posts, "posts");
    this.events = this.setup(Events, "events");
    this.announcements = this.setup(Announcements, "announcements");
    this.groupPosts = this.setup(GroupPosts, "group_posts");
    this.postlikes = this.setup(PostLikes, "post_likes");
    this.postsAndGroupPosts = this.setup(PostLikes, "posts_and_group_posts");
    this.transactions = this.setup(Transactions, "transactions");

    this.users = this.setup(Users, "users");
    this.featuredUsers = this.setup(Users, "featured_users");
    this.feeds = this.setup(Feeds, "feeds");
    this.featuredFeeds = this.setup(Feeds, "featured_feeds");
    this.groups = this.setup(Groups, "groups");
    this.grouplikes = this.setup(GroupLikes, "group_likes");
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
      other: this.setup(Posts, "posts_other"),
      meetups: this.setup(Posts, "posts_meetups")
    }
  },
  
  setup: function(collectionClass, url) {
    return new collectionClass([], { uri: this.link(url) });
  }
});

