
OrganizerApp.FileViewer = Backbone.View.extend({


  render: function() {
    if (this.model) {
      this.$(".name").text(this.model.get('name'));
    }
  },

  show: function(model) {
    this.model = model;
    this.render();
  }

});
