

var GroupPost = Repliable.extend({
  group: function(callback) {
    if (!this._group) { 
      this._group = new Group({
        links: { self: this.get("links").group }
      });
    }
    this._group.fetch({ success: callback });
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

var GroupPosts = Collection.extend({ model: GroupPost });
