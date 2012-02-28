
OrganizerApp.File = Backbone.Model.extend({
  full_name: function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  }
});

OrganizerApp.Files = Backbone.Collection.extend({

  model: OrganizerApp.File,

  initialize: function(models, options) {
    this.community = options.community;
  },
  
  url: function() {
    return "/api/communities/" + this.community + "/files";
  }

  
});
