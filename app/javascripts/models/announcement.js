
var Announcement = Repliable.extend({
  author: function() {
    if (this.get('owner_type') == "Feed") {
      return new Feed({
        links: { self: this.link('author') }
      });
    } else {
      return new User({
        links: { self: this.link('author') }
      });
    }
  },

  validate: function(attribs) {
    var missing = [];
    if (!attribs.title) { missing.push("title"); }
    if (!attribs.body) { missing.push("body"); }
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

var Announcements = Collection.extend({ model: Announcement });
