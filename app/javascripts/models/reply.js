

var Reply = Model.extend({
  user: function(callback) {
    if (!this._user) { 
      this._user = new User({
        links: { self: this.get("links").author }
      });
    }
    this._user.fetch({ success: callback });
  }
});


var Replies = Collection.extend({ model: Reply });
