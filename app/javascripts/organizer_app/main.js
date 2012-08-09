
OrganizerApp.Main = Backbone.View.extend({

  initialize: function() {
    this.fileViewer = new OrganizerApp.FileViewer({ el: this.$("#file-viewer") });

    this.filePicker = new OrganizerApp.FilePicker({ 
      el: this.$("#file-picker"),
      collection: this.collection,
      fileViewer: this.fileViewer,
      community: this.options.community
    });
  },


  render: function() {
    this.collection.fetch({ 
      success: _.bind(function() {
        _.invoke([this.filePicker], "render");
      }, this)
    });
  }

});
