
var EventForm = CommonPlace.View.extend({
  template: "main_page.forms.event-form",
  tagName: "form",
  className: "create-event event",

  events: {
    "click button": "createEvent",
    "change .post-label-selector input": "toggleCheckboxLIClass",
    "keydown textarea": "resetLayout",
    "focusout input, textarea": "onFormBlur"
  },

  afterRender: function() {
    this.$("input.date", this.el).datepicker({dateFormat: 'yy-mm-dd'});
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
    this.$("select.time").dropkick();
    var self = this;
    this.$("input.date").bind("change", function() {
      self.onFormBlur({ target: self.$("input.date") });
    });
  },

  createEvent: function(e) {
    e.preventDefault();
    this.$("button").hide();
    this.$(".spinner").show();
    var self = this;
    this.cleanUpPlaceholders();
    CommonPlace.community.events.create({ // use $.fn.serialize here
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
      success: function() {
        CommonPlace.community.events.trigger("sync");
        self.render();
      },
      error: function(attribs, response) {
        self.$("button").show();
        self.$(".spinner").hide();
        self.showError(response);
      }
    });
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  groups: function() {
    return CommonPlace.community.get('groups');
  },

  toggleCheckboxLIClass: function(e) {
    $(e.target).closest("li").toggleClass("checked");
  },

  resetLayout: function() { CommonPlace.layout.reset(); },

  time_values: _.flatten(
    _.map(
      ["AM", "PM"],
      function(half) {
        return  _.map(
          [12,1,2,3,4,5,6,7,8,9,10,11],
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
  ),
  
  onFormBlur: function(e) {
    if (!$(e.target).val() || $(e.target).val() == $(e.target).attr("placeholder")) {
      $(e.target).removeClass("filled");
    } else {
      $(e.target).addClass("filled");
    }
  }
});
