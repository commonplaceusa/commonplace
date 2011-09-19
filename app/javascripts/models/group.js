
var Group = Model.extend({
  initialize: function() {
    this.posts = new GroupPosts([], { uri: this.link("posts") });
    this.members = new Users([], { uri: this.link("members") });
    this.announcements = new Announcements([], { uri: this.link("announcements") });
    this.events = new Events([], { uri: this.link("events") });
  }
});

var Groups = Collection.extend({ model: Group });