
OrganizerApp.FileViewer = CommonPlace.View.extend({

  template: "organizer_app.file-viewer",

  show: function(model) {
    this.model = model;
    this.render();
  },

  name: function() {
    var name = this.model.get('name');
    if (name == undefined)
      return "No name";
    else
      return name;
  },

  address: function() {
    var address = this.model.get('address');
    if (address == undefined)
      return "No address in our records";
    else
      return address;
  }

});
