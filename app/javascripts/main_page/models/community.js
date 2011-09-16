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
