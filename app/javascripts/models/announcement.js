
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
  }
});

var Announcements = Collection.extend({ model: Announcement });
