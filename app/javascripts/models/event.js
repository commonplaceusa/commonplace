

var Event = Repliable.extend({
  author: function(callback) {
    if (!this._author) {
      this._author = new window[this.get('owner_type')]({
        links: { self: this.get('links').author }
      });
    }
    this._author.fetch({ success: callback });
  }
});

var Events = Collection.extend({ model: Event });
