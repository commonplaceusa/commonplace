

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
    var response = [];
    if (!attribs.title) { response.push("title"); }
    if (!attribs.body) { response.push("body"); }
    if (response.length > 0) { return response; }
  }
});

var GroupPosts = Collection.extend({ model: GroupPost });
