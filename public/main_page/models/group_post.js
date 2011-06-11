

CommonPlace.GroupPost = Backbone.Model.extend({

  initialize: function(attrs, options) {
    this.collection || (this.collection = options.collection);
    this.community = this.collection.community;
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});
  },

  group: function() {
    this._group = this._group ||
      this.community.groups.get(this.get('group_id'));
    return this._group;
  },

    url: function() { return "/api/group_posts/" + this.id; }

});

CommonPlace.GroupPosts = Backbone.Collection.extend({
  model: CommonPlace.GroupPost,

  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  url: function() {
    return "/api/communities/" + this.community.id + "/group_posts";
  },

  comparator: function(model) { return - CommonPlace.parseDate(model.get("published_at")) ; }

});
