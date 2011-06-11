


CommonPlace.Feed = Backbone.Model.extend({});

CommonPlace.Feeds = Backbone.Collection.extend({
  model: CommonPlace.Feed,
  
  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  comparator: function(feed) { return feed.get('name'); },

  url: function() {
    return "/api/communities/" + this.community.id + "/feeds";
  }
});
