
OrganizerApp.File = Backbone.Model.extend({
  getId: function() {
    return this.get('id');
  },

  full_name: function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  },

  address: function () {
    return this.get('address');
  },

  getLat: function () {
    return this.get('latitude');
  },

  getLng: function () {
    return this.get('longitude');
  },

  addEmail: function(email, callback) {
    var self = this;
	  $.ajax({
		  type: 'POST',
      contentType: "application/json",
		  url: this.url(),
		  data: email + " " + CommonPlace.community.get("zip_code"),
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
