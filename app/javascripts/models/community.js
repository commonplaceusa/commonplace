 
var Community = Model.extend({
  initialize: function() {
    this.posts = new Posts([], { uri: this.link("posts") });
    this.events = new Events([], { uri: this.link("events") });
    this.announcements = new Announcements([], { uri: this.link("announcements") });
    this.groupPosts = new GroupPosts([], { uri: this.link("group_posts") });
    this.users = new Users([], { uri: this.link("users") });
    this.feeds = new Feeds([], { uri: this.link("feeds") });
    this.groups = new Groups([], { uri: this.link("groups") });
    this.search = {
      users: new Users([], { uri: this.link("users_search") }),
      feeds: new Feeds([], { uri: this.link("feeds_search") }),
      groups: new Groups([], { uri: this.link("groups_search") }),
      groupPosts: new GroupPosts([], {uri: this.link("groupPosts_search")}),
      posts: new Posts([], {uri: this.link("posts_search")}),
      announcements: new Announcements([], {uri: this.link("announcements_search")}),
      events: new Events([], {uri: this.link("events_search")})
    };
  }
});
