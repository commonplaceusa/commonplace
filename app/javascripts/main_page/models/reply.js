
CommonPlace.Reply = Backbone.Model.extend({});

CommonPlace.Replies = Backbone.Collection.extend({

  model: CommonPlace.Reply,
  
  initialize: function(models, options) {
    this.repliable = options.repliable;
  },

  url: function() { return this.repliable.url() + "/replies"; },

  comparator: function(reply) { return CommonPlace.parseDate(reply.get("published_at")); }

});
