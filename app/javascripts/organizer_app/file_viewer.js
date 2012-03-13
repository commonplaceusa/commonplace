
OrganizerApp.FileViewer = CommonPlace.View.extend({

  template: "organizer_app.file-viewer",

  events: {
    "submit form#add-log": "addLog",
    "submit form#add-address": "addAddress",
    "submit form#add-email": "addEmail"
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
    if (!address) {
      return "No address in our records";
    } else {
      return address;
    }
  },

  addAddress: function(e) {
    e.preventDefault();
    var address = this.$("#address-text").val();
    if (!address) {
      alert("Please enter a non-empty address.");
    } else {
      this.model.save({address: address}, {success: _.bind(this.render, this)});
      location.reload();
    }
  },

  email: function() {
    var email = this.model.get('email');
    console.log(email);
    if (!email) {
      return "No email in our records";
    } else {
      return email;
    }
  },

  addEmail: function(e) {
    e.preventDefault();
    var email = this.$("#email-text").val();
    var atpos = email.indexOf("@");
    var dotpos = email.lastIndexOf(".");
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {
      alert("Please enter a valid email address.");
    } else {
      this.model.save({email: email}, {success: _.bind(this.render, this)});
      location.reload();
    }
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
