var Feed = Model.extend({
  initialize: function() {
    this.announcements = new Announcements([], { uri: this.link("announcements") });
    this.events = new Events([], { uri: this.link("events") });
    this.subscribers = new Users([], { uri: this.link("subscribers") });
    this.owners = new FeedOwners([], { uri: this.link("owners") });
  },
  
  validate: function(attribs) {
    var missing = [];
    if (!attribs.name) { missing.push("feed name"); }
    if (!attribs.slug) { missing.push("nickname"); }
    if (missing.length > 0) {
      var responseText = "Please fill in the " + missing.shift();
      _.each(missing, function(field) {
        responseText = responseText + " and " + field;
      });
      var response = {
        status: 400,
        responseText: responseText + "."
      };
      return response;
    }
  }
});

var Feeds = Collection.extend({
  model: Feed
});
