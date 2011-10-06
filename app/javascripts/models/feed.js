var Feed = Model.extend({
  initialize: function() {
    this.announcements = new Announcements([], { uri: this.link("announcements") });
    this.events = new Events([], { uri: this.link("events") });
    this.subscribers = new Users([], { uri: this.link("subscribers") });
  }
});

var Feeds = Collection.extend({
  model: Feed,

  search: function(query) {
    this.uri = "/search/community/1/feeds?query=" + query;
  }
});
