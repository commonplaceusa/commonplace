

var GroupPost = Repliable.extend({
  group: function(callback) {
    if (!this._group) { 
      this._group = new Group({
        links: { self: this.get("links").group }
      });
    }
    this._group.fetch({ success: callback });
  }
});

var GroupPosts = Collection.extend({ model: GroupPost });