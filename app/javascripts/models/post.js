
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

var Posts = Collection.extend({ model: Post });
