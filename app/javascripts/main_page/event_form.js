
var EventForm = CommonPlace.View.extend({
  template: "main_page/event-form",
  tagName: "form",
  className: "create-event",

  events: {
    "submit": "createEvent",
    "change .post-label-selector input": "toggleCheckboxLIClass"
  },

  afterRender: function() {
    this.$("input.date", this.el).datepicker({dateFormat: 'yy-mm-dd'});
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
    this.$("select.time").dropkick();
  },

  createEvent: function(e) {
    e.preventDefault();
    var self = this;
    this.cleanUpPlaceholders();
    this.collection.create({ 
      title:   this.$("[name=title]").val(),
      about:   this.$("[name=about]").val(),
      date:    this.$("[name=date]").val(),
      start:   this.$("[name=start]").val(),
      end:     this.$("[name=end]").val(),
      venue:   this.$("[name=venue]").val(),
      address: this.$("[name=address]").val(),
      tags:    this.$("[name=tags]").val(),
      groups:  this.$("[name=groups]:checked").map(function() { 
        return $(this).val(); 
      }).toArray()
    }, {
      success: function() { self.render(); },
      error: function(attribs, response) { self.incomplete(response); }
    });
  },

  incomplete: function(fields) {
    var incompleteFields = fields.shift();
    var self = this;
    _.each(fields, function(f) {
      incompleteFields = incompleteFields + " and " + f;
    });
    this.$(".incomplete-fields").text(incompleteFields);
    this.$(".incomplete").show();
  },

  groups: function() {
    return this.options.community.get('groups');
  },

  toggleCheckboxLIClass: function(e) {
    $(e.target).closest("li").toggleClass("checked");
  },

  time_values: _.flatten(
    _.map(
      ["AM", "PM"],
      function(half) {
        return  _.map(
          _.range(1,13),
          function(hour) {
            return _.map(
              ["00", "30"],
              function(minute) {
                return String(hour) + ":" + minute + " " + half;
              }
            );
          }
        );
      }
    )
  )
});
