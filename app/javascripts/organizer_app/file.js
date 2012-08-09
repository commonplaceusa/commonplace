
OrganizerApp.File = Backbone.Model.extend({
  urlRoot: function () {
    return "/api/communities/" + window.location.toString().split('/')[4] + "/files/";
  },

  getId: function() {
    return this.get('id');
  },

  full_name: function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  },

  email: function() {
    return this.get('email');
  },

  phone: function() {
    return this.get('phone');
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
    //console.log("addLog's URL: ", this.url());
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
  },

  manualtags: function(){
    return this.get('manualtags');
  },
  actionstags: function(){
    return this.get('actionstags');
  }
});

OrganizerApp.Files = Backbone.Collection.extend({

  model: OrganizerApp.File,

  initialize: function(models, options) {
    this.community = options.community;
  },

  url: function() {
    return "/api/communities/" + this.community.id + "/files";
  },

  commontags: function(){
    var tags= new Array();
    var actions= [];
    actions= actions.concat(this.models[0].actionstags());
      tags=tags.concat(this.models[0].manualtags());
      _.map(this.models, function(model){
        if((t=model.manualtags()).length>0){
          intersect={},res=[];
          for (var i=tags.length-1; i>=0; i--) {
	    for ( var j=0; j<t.length; j++) {
		if (tags[i]==t[j]) {
			intersect[tags[i]]=true;
		}
	    }
          }
        tags= new Array();
        for(var k in intersect)
	  tags.push(k);
        }
      });

    _.map(this.models, function(model){
      if((t=model.actionstags()).length>0){
        //console.log(model.manualtags());
        intersect={},res=[];
        for (var i=actions.length-1; i>=0; i--) {
	  for ( var j=0; j<t.length; j++) {
		if (actions[i]==t[j]) {
			intersect[actions[i]]=true;
		}
	  }
        }
      actions= new Array();
      for(var k in intersect)
	actions.push(k);
      }
    });
    var all=tags.concat(actions);
    return all;
  }

});
