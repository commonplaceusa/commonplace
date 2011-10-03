

var Event = Repliable.extend({
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
    if (!attribs.about) { response.push("body"); }
    if (!attribs.date) { response.push("date"); }
    if (response.length > 0) { return response; }
  }
});

var Events = Collection.extend({ model: Event });
