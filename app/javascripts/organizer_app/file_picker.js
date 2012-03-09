
OrganizerApp.FilePicker = Backbone.View.extend({

  events: {
    "click li": "onClickFile",
    "click #filter-button": "filter"
  },
  
  onClickFile: function(e) {
    e.preventDefault();
    this.options.fileViewer.show($(e.currentTarget).data('model'));
  },
  
  render: function() {
    this.$("#file-picker-list").empty();
    this.$("#file-picker-list").append(
      this.collection.map(_.bind(function(model) {
        return $("<li/>", { text: model.full_name(), data: { model: model } })[0];
      }, this)));
  },

  filter: function() {

    var filters = _.groupBy(this.$("#filter-input").val().split(","), 
                            function(string) {
                              return string[0] === "!" ? "without": "with"
                            });

    filters.without = _.map(filters.without, 
                            function(string) { return string.slice(1) });

    this.collection.fetch({ 
      data: {"with": filters["with"], without: filters.without},
      success: _.bind(this.render, this)
    });
  }
});
