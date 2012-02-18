
OrganizerApp.File = Backbone.Model.extend({

});

OrganizerApp.Files = Backbone.Collection.extend({

  initialize: function(models, options) {
    this.community = options.community;
  },
  
  url: function() {
    return "/api/communities/" + this.community + "/files";
  }
  
});
