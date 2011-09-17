
CommonPlace.Group = Backbone.Model.extend({});

CommonPlace.Groups = Backbone.Collection.extend({
  model: CommonPlace.Group,
  
  initialize: function(models, options) {
    this.community = options.community;
    return this;
  },

  comparator: function(group) { return group.get('name'); },

  url: function() {
    return "/api/communities/" + this.community.id + "/groups";
  }

});