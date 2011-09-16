

CommonPlace.Post = Backbone.Model.extend({

  initialize: function(attrs, options) {
    this.collection || (this.collection = options.collection);
    this.community = this.collection.community;
    this.user = this.community.users.get(this.get('user_id'));
    this.replies = new CommonPlace.Replies(this.get('replies'), {repliable: this});
  },

  url: function() { return this.isNew() ? "/api/communities/" + this.community.id + "/posts" : "/api/posts/" + this.id; }
    
});

CommonPlace.Posts = Backbone.Collection.extend({
  
  model: CommonPlace.Post,

  comparator: function(model) { return - CommonPlace.parseDate(model.get("last_activity")); },


  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  url: function() {
    if (this.community.get('locale') === "college") {
      return "/api/neighborhoods/" + CommonPlace.account.get("neighborhood") + "/posts";
    } else {
      return "/api/communities/" + this.community.id + "/posts";
    }
  }
});