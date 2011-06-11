
CommonPlace.User = Backbone.Model.extend({});

CommonPlace.Users = Backbone.Collection.extend({
  model: CommonPlace.User,
  
  initialize: function(models,options) {
    this.community = options.community;
    return this;
  },

  comparator: function(user) { return user.get('last_name') + user.get('first_name'); },

  url: function() {
    return "/api/communities/" + this.community.id + "/users";
  }
});