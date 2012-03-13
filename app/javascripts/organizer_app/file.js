
OrganizerApp.File = Backbone.Model.extend({
  full_name: function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  },

  addEmail: function(email, callback) {
    var self = this;
	  $.ajax({
		  type: 'POST',
      contentType: "application/json",
		  url: this.url(),
		  data: email,
		  cache: 'false',
		  success: function() {
        self.fetch({success: callback});
      }
	  });
  },

  addLog: function(log, callback) {
    var self = this;
	  $.ajax({
		  type: 'POST',
      contentType: "application/json",
		  url: this.url() + "/logs",
		  data: JSON.stringify(log),
		  cache: 'false',
		  success: function() {
        self.fetch({success: callback});
      }
	  });
  }
});

OrganizerApp.Files = Backbone.Collection.extend({

  model: OrganizerApp.File,

  initialize: function(models, options) {
    this.community = options.community;
  },
  
  url: function() {
    return "/api/communities/" + this.community.id + "/files";
  }

  
});
