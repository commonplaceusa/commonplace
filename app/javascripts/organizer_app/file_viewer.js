
OrganizerApp.FileViewer = CommonPlace.View.extend({

  template: "organizer_app.file-viewer",

  show: function(model) {
    this.model = model;
    this.render();
  },

  name: function() {
    return this.model.get('name');
  },

  address: function() {
    return this.model.get('address');
  }

});
