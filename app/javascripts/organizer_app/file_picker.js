
OrganizerApp.FilePicker = CommonPlace.View.extend({

  template: "organizer_app.file-picker",

  events: {
    "click li": "onClickFile",
    "click #filter-button": "filter",
    "click .tag-filter": "cycleFilter",
  },
  
  onClickFile: function(e) {
    e.preventDefault();
    this.options.fileViewer.show($(e.currentTarget).data('model'));
  },

  showMapView: function(e) {
    new OrganizerApp.MapView({el: $('#file-viewer'), collection: this.collection, filePicker: this}).render();
  },

  afterRender: function() {
    this.renderList(this.collection.models);
  },

  renderList: function(list) {
    this.$("#file-picker-list").empty();
    console.log(list);
    this.$("#file-picker-list").append(
      _.map(list, _.bind(function(model) {
        console.log("renderList model: ");
        console.log(model);
        console.log("model url: ", model.url());
        var li = $("<li/>", { text: model.full_name(), data: { model: model } })[0];
        $(li).addClass("pick-resident");
        return li;
      }, this))); 
  },

  filter: function() {
    var params = {
      "with": _.map(this.$(".tag-filter[data-state=on]").toArray(), function(e) { 
        return $(e).attr("data-tag");
      }).join(","),
      without: _.map(this.$(".tag-filter[data-state=off]").toArray(), function(e) { 
        return $(e).attr("data-tag");
      }).join(","),
      query: this.$("#query-input").val()
    };
    
    this.collection.fetch({ 
      data: params,
      success: _.bind(this.afterRender, this)
    });
    this.showMapView();
  },

  tags: function() { possTags = this.options.community.get('resident_tags'); return this.options.community.get('resident_tags'); },

  cycleFilter: function(e) {
    window.foo = this;
    e.preventDefault();
    var state = $(e.currentTarget).attr("data-state");
    var newState = { neutral: "on", on: "off", off: "neutral"}[state];
    $(e.currentTarget).attr("data-state", newState);
  }
    
});
