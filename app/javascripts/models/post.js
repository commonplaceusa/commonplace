
var Post = Repliable.extend({
  user: function(callback) {
    if (!this._user) {
      this._user = new User({
        links: { self: this.get("links").author }
      });
    }
    this._user.fetch({ success: callback });
  },

  validate: function(attribs) {
    var response = [];
    if (!attribs.title) { response.push("title"); }
    if (!attribs.body) { response.push("body"); }
    if (response.length > 0) { return response; }
  }
});

var Posts = Collection.extend({ model: Post });
