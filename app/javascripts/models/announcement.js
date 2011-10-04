
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
    var response = [];
    if (!attribs.title) { response.push("title"); }
    if (!attribs.body) { response.push("body"); }
    if (response.length > 0) { return response; }
  }
});

var Announcements = Collection.extend({ model: Announcement });
