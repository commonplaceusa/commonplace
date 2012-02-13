Model = Backbone.Model.extend({
  url: function() {
    if (this.get('links') && this.get('links').self) {
      return "/api" + this.get('links').self;
    } else {
      return Backbone.Model.prototype.url.call(this); // super
    }
  },
  
  link: function(name) {
    return this.get("links")[name];
  }
});

Collection = Backbone.Collection.extend({
  initialize: function(models,options) { this.uri = options.uri; },
  url: function() { return "/api" + this.uri; }
}); 

Repliable = Model.extend({
  replies: function() {
    return new Replies(_.map(this.get("replies"), function(reply) {
      return new Reply(reply);
    }), { uri: this.link("replies") });
  }
});

Repliables = Collection.extend({ model: Repliable });
