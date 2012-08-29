
OrganizerApp.Main = Backbone.View.extend({

  initialize: function() {
    page = 1;
    per = 75;
    this.fileViewer = new OrganizerApp.FileViewer({ el: this.$("#file-viewer") });

    this.filePicker = new OrganizerApp.FilePicker({
      el: this.$("#file-picker"),
      collection: this.collection,
      fileViewer: this.fileViewer,
      community: this.options.community
    });
  },


  render: function() {
    var params = {
      "page": page,
      "per": per
    };
    this.collection.fetch({
      data: params,
      success: _.bind(function() {
        _.invoke([this.filePicker], "render");
      }, this),
    });
  }

});
