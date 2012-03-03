
OrganizerApp.File = Backbone.Model.extend({
  full_name: function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  },

  addLog: function() {
    url = this.url() + "/logs";
    text = $("#log-text").val();
	$.ajax({
		type: 'POST',
		url: url,
		data: text,
		cache: 'false',
		success: function(response){		
            console.log("ajax success");
            $("#person-viewer").append("<br />" + text);
		},
        error: function(response){
            console.log("ajax error");
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
    return "/api/communities/" + this.community + "/files";
  }

  
});
