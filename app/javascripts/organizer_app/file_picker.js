
OrganizerApp.FilePicker = Backbone.View.extend({

  initialize: function() { },

  events: {
    "click li": "onClickFile"
  },

  onClickFile: function(e) {
    e.preventDefault();
    this.options.fileViewer.show($(e.currentTarget).data('model'));
  },
  
  render: function() {
    this.$("#file-picker-list").append(
      this.collection.map(_.bind(function(model) {
        return $("<li/>", { text: model.get('first_name') + ' ' + model.get('last_name'), data: { model: model } })[0];
      }, this)));
  }
});
