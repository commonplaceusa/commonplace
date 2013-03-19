var Feed = Model.extend({
  initialize: function() {
    this.announcements = new Announcements([], { uri: this.link("announcements") });
    this.events = new Events([], { uri: this.link("events") });
    this.subscribers = new Users([], { uri: this.link("subscribers") });
    this.transactions = new Transactions([], { uri: this.link("transactions") });
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
  },

  cropAvatar: function(coords, callback) {
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get("links").crop,
      type: "put",
      dataType: "json",
      data: JSON.stringify({
        crop_x: coords.crop_x,
        crop_y: coords.crop_y,
        crop_w: coords.crop_w,
        crop_h: coords.crop_h
      }),
      success: _.bind(function(feed) {
        this.set(feed);
        if (callback) { callback(); }
      }, this)
    });
  },

  deleteAvatar: function(callback) {
    var self = this;
    $.ajax({
      contentType: "application/json",
      url: "/api" + this.get('links').avatar_edit,
      type: "delete",
      dataType: "json",
      success: function(account) {
        self.set(account);
        callback && callback();
      }
    });
  }
});

var Feeds = Collection.extend({
  model: Feed
});
