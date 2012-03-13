
OrganizerApp.FileViewer = CommonPlace.View.extend({

  template: "organizer_app.file-viewer",

  events: {
    "submit form#add-log": "addLog"
  },

  show: function(model) {
    this.model = model;
    this.render();
    this.$("#log-add").click($.proxy(function() {
      this.model.addLog();
    }, this));
    this.$("#datepicker").datepicker();
  },

  full_name: function() {
    var name = this.model.full_name();
    if (name === undefined) {
      return "No name";
    } else {
      return name;
    }
  },

  address: function() {
    var address = this.model.get('address');
    if (address === undefined) {
      return "No address in our records";
    } else {
      return address;
    }
  },

  email: function() {
    var email = this.model.get('email');
    console.log(email);
    if (email === undefined) {
      return "No email in our records";
    } else {
      return email;
    }
  },

  addEmail: function(e) {
    e.preventDefault();
    this.model.save({email: this.$("#email-text").val()}, {success: _.bind(this.render, this)});
  },
  
  addLog: function(e) {
    e.preventDefault();
    this.model.addLog({ 
      date: this.$("#log-date").val(),
      text: this.$("#log-text").val(),
      tags: _.map(this.$("#log-tags").val().split(","), $.trim)
    }, _.bind(this.render,this));
  },

  logs: function() { return this.model.get('logs'); },

  tags: function() { return this.model.get('tags'); },

  possibleTags: function() { return possTags; }

});
