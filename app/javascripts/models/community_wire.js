var CommunityWire = Model.extend({
  initialize: function(options) {
    this.uri = "/api" + options.uri;
  },
  
  fetch: function(data, callback) {
    var self = this;
    $.getJSON(this.uri, data, function(response) {
      self.neighborhood = new Posts(response["neighborhood"], CommonPlace.community.categories.neighborhood);
      self.offers = new Posts(response["offers"], CommonPlace.community.categories.offers);
      self.help = new Posts(response["help"], CommonPlace.community.categories.help);
      self.publicity = new Posts(response["publicity"], CommonPlace.community.categories.publicity);
      self.other = new Posts(response["other"], CommonPlace.community.other);
      self.announcements = new Announcements(response["announcements"], CommonPlace.community.announcements);
      self.groupPosts = new GroupPosts(response["group"], CommonPlace.community.groupPosts);
      self.events = new Events(response["events"], CommonPlace.community.events);
      if (callback) { callback() };
    });
  },
});
