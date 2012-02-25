
OrganizerApp.FilePicker = Backbone.View.extend({

  initialize: function() { },

  events: {
    "click li": "onClickFile",
    "click input:checked": "filter",
    "click input:not(:checked)": "unfilter"
  },

  onClickFile: function(e) {
    e.preventDefault();
    this.options.fileViewer.show($(e.currentTarget).data('model'));
  },
  
  render: function() {
    this.$("#file-picker-list").append(
      this.collection.map(_.bind(function(model) {
        return $("<li/>", { text: model.get('name'), data: { model: model } })[0];
      }, this)));
  },

  filter: function(e) {
    /*console.log($(e.currentTarget));*/
    this.$("#file-picker-list li:visible").filter(function() {
      var passesFilters = true;
      var person = this;
      return !$(person).data("model").get($(e.currentTarget).attr('id'));
    }).hide();
  },

  unfilter: function(e) {
    /*console.log($(e.currentTarget));*/
    this.$("#file-picker-list li").filter(function() {
      var passesFilters = true;
    
      var person = this;
      $("#file-picker-filters input:checked").each(function(index) {
        
        passesFilters = $(person).data("model").get($(this).attr('id')) && passesFilters;
      });
      return passesFilters;
    }).css({ display: "block" });
  }
});
