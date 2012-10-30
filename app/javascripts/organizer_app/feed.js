OrganizerApp.Feed = Backbone.Model.extend({
  urlRoot: function () {
    return "/api/communities/" + window.location.toString().split('/')[4] + "/org_feeds/";
  },

  getId: function() {
    return this.get('id');
  },

  getUserid: function() {
    return this.get('user_id');
  },

  count: function() {
    return this.get('subscribers_count');
  },

  name: function() {
    return this.get('name');
  },

  phone: function() {
    return this.get('phone');
  }
});

OrganizerApp.Feeds = Backbone.Collection.extend({

  model: OrganizerApp.Feed,

  initialize: function(models, options) {
    this.community = options.community;
  },

  url: function() {
    return "/api/communities/" + this.community.id + "/org_feeds";
  },

  modelIds: function() {
    var userids= new Array();
    _.each(this.models, function(model){ userids.push(model.getUserid())});
    var residentids= new Array();
    _.each(this.models, function(model){ residentids.push(model.getId())});
    return {userids: userids, residentids: residentids};
  }
});
